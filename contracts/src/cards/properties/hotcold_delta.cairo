
// This file is generated. Do not edit! 
// Edit the cards.csv instead and regenerate

use array::ArrayTrait;
use option::OptionTrait;
use traits::TryInto;
fn get(card_id: u128) -> Option<u32> {
    let a: Array<Option<u32>> = array![
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
        Option::Some(2),
        Option::None,
        Option::None,
        Option::None,
        Option::None,
        Option::None,
        Option::None,
        Option::None,
        Option::None,
        Option::None,
        Option::Some(2),
        Option::Some(3),
        Option::None,
        Option::None,
        Option::None,
        Option::None,
        Option::None,
        Option::None,
        Option::Some(3),
        Option::None,
        Option::Some(2),
        Option::None,
        Option::Some(1),
        Option::None,
        Option::Some(3),
        Option::None,
        Option::None,
        Option::None,
        Option::None,
        Option::None,
        Option::None,
        Option::None,
        Option::Some(1),
        Option::None,
        Option::None,
        Option::None,
        Option::None,
        Option::Some(2),
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
        Option::Some(1),
        Option::Some(2),
        Option::None,
        Option::Some(1),
        Option::None,
        Option::None,
        Option::Some(2),
        Option::Some(1),
        Option::None,
        Option::None,
        Option::None,
        Option::None,
        Option::Some(3),
        Option::Some(3),
        Option::Some(1),
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
        Option::Some(2),
        Option::Some(1),
        Option::Some(2),
        Option::None,
        Option::None,
        Option::None,
        Option::None,
        Option::None,
        Option::None,
        Option::Some(2),
        Option::None,
        Option::None,

    ];
    // card indices should never exceed u32 size
    *a.at(card_id.try_into().unwrap())
}
