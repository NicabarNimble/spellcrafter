use spellcrafter::types::{Region, FamiliarType};

#[starknet::interface]
trait ISpellCrafter<TContractState> {
    fn new_game(self: @TContractState) -> u128;
    fn forage(self: @TContractState, game_id: u128, region: Region) -> u128;
    fn interact(self: @TContractState, game_id: u128, item_id: u128);
    fn summon(self: @TContractState, game_id: u128, familiar_type: FamiliarType) -> u128;
    fn sacrifice(self: @TContractState, game_id: u128, familiar_id: u128);
}

#[dojo::contract]
mod spellcrafter_system {
    use super::ISpellCrafter;
    use starknet::{get_caller_address};
    use core::zeroable::Zeroable;
    use spellcrafter::constants::{
        INITIAL_BARRIERS, BARRIERS_STAT, HOTCOLD_STAT, LIGHTDARK_STAT, POLAR_STAT_MIDPOINT,
        CHAOS_STAT, ITEMS_HELD, CHAOS_PER_FORAGE, ITEM_LIMIT, FAMILIAR_LIMIT, FAMILIARS_HELD,
        TICKS_PER_SUMMON, BARRIERS_LIMIT,
    };
    use spellcrafter::types::{Region, FamiliarType, FamiliarTypeTrait};
    use spellcrafter::components::{Owner, ValueInGame, Familiar};
    use spellcrafter::utils::assertions::{assert_caller_is_owner, assert_is_alive, assert_is_familiar, assert_is_unoccupied};
    use spellcrafter::utils::random::pass_check;
    use spellcrafter::cards::selection::random_card_from_region;
    use spellcrafter::cards::actions::{
        increase_stat, decrease_stat, stat_meets_threshold, enact_card, is_dead, bust_barrier, tick,
    };

    #[external(v0)]
    impl SpellCrafterImpl of ISpellCrafter<ContractState> {
        fn new_game(self: @ContractState) -> u128 {
            let world = self.world_dispatcher.read();
            let game_id: u128 = world.uuid().into();
            set!(
                world,
                (
                    Owner { entity_id: game_id, address: get_caller_address() },
                    ValueInGame { entity_id: BARRIERS_STAT, game_id, value: INITIAL_BARRIERS },
                    ValueInGame { entity_id: HOTCOLD_STAT, game_id, value: POLAR_STAT_MIDPOINT },
                    ValueInGame { entity_id: LIGHTDARK_STAT, game_id, value: POLAR_STAT_MIDPOINT }
                )
            );
            game_id
        }

        // In the context of a particular game, forage in a given region
        // This will add a random spell component to the players hand
        fn forage(self: @ContractState, game_id: u128, region: Region) -> u128 {
            let world = self.world_dispatcher.read();
            assert_caller_is_owner(world, get_caller_address(), game_id);
            assert_is_alive(world, game_id);
            assert(
                !stat_meets_threshold(
                    world, game_id, ITEMS_HELD, Option::Some((ITEM_LIMIT, false))
                ),
                'Too many items held'
            );

            // TODO This is not simulation safe. Ok for quick protyping only
            let tx_info = starknet::get_tx_info().unbox();
            let seed = tx_info.transaction_hash;

            let card_id = random_card_from_region(seed, region);

            // increase chaos by a fixed amount. In the future this will be a function of time
            increase_stat(world, game_id, CHAOS_STAT, CHAOS_PER_FORAGE);
            // increase the number of that card
            increase_stat(world, game_id, card_id, 1);
            // increase the total number of items held
            increase_stat(world, game_id, ITEMS_HELD, 1);

            return card_id;
        }

        // Place a card owned by the player in this game into the spell
        fn interact(self: @ContractState, game_id: u128, item_id: u128) {
            let world = self.world_dispatcher.read();
            assert_caller_is_owner(world, get_caller_address(), game_id);
            assert_is_alive(world, game_id);

            // TODO This is not simulation safe. Ok for quick protyping only
            let tx_info = starknet::get_tx_info().unbox();
            let seed = tx_info.transaction_hash;

            let owned = get!(world, (item_id, game_id), ValueInGame).value;
            assert(owned > 0, 'Item is not owned');

            let chaos = get!(world, (CHAOS_STAT, game_id), ValueInGame).value;

            if !pass_check(seed, chaos) {
                bust_barrier(world, game_id);
            }

            if !is_dead(world, game_id) {
                enact_card(world, game_id, item_id);
            }
        }

        // summon a familiar which can be sent to retrieve items. Returns the entity ID of the familiar
        fn summon(self: @ContractState, game_id: u128, familiar_type: FamiliarType) -> u128 {
            let world = self.world_dispatcher.read();
            assert_caller_is_owner(world, get_caller_address(), game_id);
            assert_is_alive(world, game_id);
            assert(
                !stat_meets_threshold(
                    world, game_id, FAMILIARS_HELD, Option::Some((FAMILIAR_LIMIT, false))
                ),
                'Too many familiars'
            );
            // Move time forward, also increase chaos
            tick(world, game_id, TICKS_PER_SUMMON);

            // create a new entity for the familiar
            let entity_id: u128 = world.uuid().into();
            set!(
                world,
                (
                    Familiar { entity_id, game_id, familiar_type_id: familiar_type.stat_id() },
                    Owner { entity_id, address: get_caller_address() },
                )
            );

            // increase the total number of familiars held in this game
            increase_stat(world, game_id, FAMILIARS_HELD, 1);

            return entity_id;
        }

        fn sacrifice(self: @ContractState, game_id: u128, familiar_id: u128) {
            let world = self.world_dispatcher.read();
            assert_caller_is_owner(world, get_caller_address(), game_id);
            assert_is_alive(world, game_id);
            assert_is_familiar(world, game_id, familiar_id); // can only sacrifice familiar entities
            assert_caller_is_owner(world, get_caller_address(), familiar_id); // can only sacrifice familiars you own
            assert_is_unoccupied(world, game_id, familiar_id); // can only sacrifice them if they are unoccupied

            // set the owner of a familiar to the zero address to mark it as sacrificed
            set!(
                world,
                (
                    Owner { entity_id: familiar_id, address: Zeroable::zero() },
                )
            );

            if !stat_meets_threshold(world, game_id, BARRIERS_STAT, Option::Some((BARRIERS_LIMIT, true))) {
                increase_stat(world, game_id, BARRIERS_STAT, 1);
            }
            decrease_stat(world, game_id, FAMILIARS_HELD, 1);

        }
    }
}


#[cfg(test)]
mod forage_tests {
    use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};

    use spellcrafter::types::Region;
    use spellcrafter::utils::testing::{deploy_game, SpellcraftDeployment};
    use spellcrafter::components::{Owner, ValueInGame};
    use spellcrafter::constants::{ITEMS_HELD, ITEM_LIMIT};

    use super::{spellcrafter_system, ISpellCrafterDispatcher, ISpellCrafterDispatcherTrait};

    #[test]
    #[available_gas(300000000000)]
    fn test_forage() {
        let SpellcraftDeployment{world, system, } = deploy_game();

        let game_id = system.new_game();
        let card_id = system.forage(game_id, Region::Forest);

        // post conditions
        let card = get!(world, (card_id, game_id), ValueInGame);
        assert(card.value == 1, 'failed to add ingredient');
    }

    #[test]
    #[available_gas(300000000000)]
    #[should_panic(expected: ('Too many items held', 'ENTRYPOINT_FAILED'))]
    fn cannot_exceed_max_items() {
        let SpellcraftDeployment{world, system } = deploy_game();

        let game_id = system.new_game();

        // // pre conditions
        let items = get!(world, (ITEMS_HELD, game_id), ValueInGame).value;
        assert(items == 0, 'not initially no items');

        let mut i = 0;
        loop {
            if i >= ITEM_LIMIT {
                break;
            }
            system.forage(game_id, Region::Forest);
            i += 1;
        };

        // post conditions
        let items = get!(world, (ITEMS_HELD, game_id), ValueInGame).value;
        assert(items == ITEM_LIMIT, 'not expected n_items');

        // should fail
        system.forage(game_id, Region::Forest);
    }
}

#[cfg(test)]
mod interact_tests {
    use traits::{Into, TryInto};
    use result::ResultTrait;
    use array::ArrayTrait;
    use option::OptionTrait;
    use serde::Serde;

    use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
    use dojo::test_utils::deploy_contract;

    use spellcrafter::utils::testing::{deploy_game, SpellcraftDeployment};
    use spellcrafter::components::{Owner, ValueInGame};

    use super::{spellcrafter_system, ISpellCrafterDispatcher, ISpellCrafterDispatcherTrait};

    #[test]
    #[should_panic(expected: ('Item is not owned', 'ENTRYPOINT_FAILED'))]
    #[available_gas(300000000000)]
    fn reverts_if_card_not_owned() {
        let CARD_ID: u128 = 1;

        let SpellcraftDeployment{world, system, } = deploy_game();

        let game_id = system.new_game();
        system.interact(game_id, CARD_ID);
    }

    #[test]
    #[available_gas(300000000000)]
    fn works_if_card_owned() {
        let CARD_ID: u128 = 1;

        let SpellcraftDeployment{world, system } = deploy_game();

        let game_id = system.new_game();

        set!(world, ValueInGame { entity_id: CARD_ID, game_id: game_id, value: 1 });
        system.interact(game_id, CARD_ID);
    }
}

#[cfg(test)]
mod summon_tests {
    use traits::{Into, TryInto};
    use result::ResultTrait;
    use array::ArrayTrait;
    use option::OptionTrait;
    use serde::Serde;

    use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
    use dojo::test_utils::deploy_contract;

    use spellcrafter::utils::testing::{deploy_game, SpellcraftDeployment};
    use spellcrafter::components::{Owner, ValueInGame, Familiar};
    use spellcrafter::types::{FamiliarType, FamiliarTypeTrait};
    use spellcrafter::constants::{FAMILIARS_HELD, FAMILIAR_LIMIT};

    use super::{spellcrafter_system, ISpellCrafterDispatcher, ISpellCrafterDispatcherTrait};

    #[test]
    #[available_gas(300000000000)]
    fn can_summon_on_new_game() {
        let SpellcraftDeployment{world, system } = deploy_game();
        let game_id = system.new_game();
        let familiar_entity_id = system.summon(game_id, FamiliarType::Cat);

        // post conditions
        let familiar = get!(world, (familiar_entity_id), Familiar);
        assert(familiar.familiar_type_id == FamiliarType::Cat.stat_id(), 'familiar type not set');
        let familiars_held = get!(world, (FAMILIARS_HELD, game_id), ValueInGame).value;
        assert(familiars_held == 1, 'familiars_held not incremented');
    }

    #[test]
    #[should_panic(expected: ('Too many familiars', 'ENTRYPOINT_FAILED'))]
    #[available_gas(300000000000)]
    fn cannot_exceed_limit() {
        let SpellcraftDeployment{world, system } = deploy_game();
        let game_id = system.new_game();

        let mut i = 0;
        loop {
            if i >= FAMILIAR_LIMIT {
                break;
            }
            system.summon(game_id, FamiliarType::Raven);
            i += 1;
        };

        // post conditions
        let familiars_held = get!(world, (FAMILIARS_HELD, game_id), ValueInGame).value;
        assert(familiars_held == 1, 'familiars_held not incremented');

        // should panic
        system.summon(game_id, FamiliarType::Raven);
    }    
}
