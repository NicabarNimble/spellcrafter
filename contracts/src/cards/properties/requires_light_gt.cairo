// File: src/cards/properties/requires_light_gt.cairo

// This file is generated. Do not edit! 
// Edit the cards.csv instead and regenerate

use array::ArrayTrait;
use option::OptionTrait;
use traits::TryInto;
fn get(card_id: u128) -> Option<(u32, bool)> {
    let a: Array<Option<(u32, bool)>> = array![
        Option::None,
        Option::None,
        Option::None,
        Option::None,
        Option::None,
        Option::None,
        Option::None,
        Option::None,
        Option::None,
        Option::None,
        Option::None,
        Option::None,
        Option::None,
        Option::None,
        Option::None,
        Option::None,
        Option::None,
        Option::None,
        Option::None,
        Option::None,
        Option::None,
        Option::None,
        Option::None,
        Option::Some((2, false)),
        Option::None,
        Option::None,
        Option::None,
        Option::None,
        Option::None,
        Option::None,
        Option::None,
        Option::None,
        Option::None,
        Option::None,
        Option::None,
        Option::None,
        Option::None,
        Option::None,
        Option::Some((2, false)),
        Option::None,
        Option::None,
        Option::None,
        Option::Some((3, false)),
        Option::Some((3, false)),
        Option::Some((6, false)),
        Option::None,
        Option::None,
        Option::None,
        Option::Some((3, false)),
        Option::None,
        Option::None,
        Option::None,
        Option::None,
        Option::None,
        Option::Some((10, false)),
        Option::None,
        Option::None,
        Option::Some((3, false)),
        Option::Some((2, false)),
        Option::None,
        Option::None,
        Option::None,
        Option::None,
        Option::None,
        Option::None,
        Option::None,
        Option::None,
        Option::None,
        Option::None,
        Option::None,
        Option::None,
        Option::None,
        Option::None,
        Option::None,
        Option::None,
        Option::None,
        Option::None,
        Option::None,
        Option::None,
        Option::None,
        Option::None,
        Option::Some((3, false)),
        Option::None,
        Option::None,
        Option::None,
        Option::None,
        Option::None,
        Option::None,
        Option::None,
        Option::None,
        Option::None,
        Option::None,
        Option::None,
        Option::Some((2, false)),
        Option::None,
        Option::None,
        Option::None,
        Option::None,
        Option::None,
        Option::None,
        Option::None,

    ];
    // card indices should never exceed u32 size
    *a.at(card_id.try_into().unwrap())
}
