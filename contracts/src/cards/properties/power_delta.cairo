// File: src/cards/properties/power_delta.cairo

// This file is generated. Do not edit! 
// Edit the cards.csv instead and regenerate

use array::ArrayTrait;
use option::OptionTrait;
use traits::TryInto;
fn get(card_id: u128) -> Option<(u32, bool)> {
    let a: Array<Option<(u32, bool)>> = array![
        Option::Some((3, false)),
        Option::Some((1, false)),
        Option::Some((1, true)),
        Option::Some((1, false)),
        Option::Some((3, false)),
        Option::Some((2, false)),
        Option::Some((1, false)),
        Option::Some((1, false)),
        Option::None,
        Option::Some((3, false)),
        Option::Some((4, false)),
        Option::None,
        Option::Some((1, true)),
        Option::Some((1, false)),
        Option::Some((3, false)),
        Option::Some((1, true)),
        Option::Some((2, false)),
        Option::Some((2, false)),
        Option::None,
        Option::Some((2, false)),
        Option::None,
        Option::Some((2, false)),
        Option::Some((3, false)),
        Option::None,
        Option::Some((1, true)),
        Option::None,
        Option::None,
        Option::Some((2, false)),
        Option::Some((1, false)),
        Option::None,
        Option::Some((2, false)),
        Option::Some((1, false)),
        Option::None,
        Option::Some((1, false)),
        Option::Some((1, false)),
        Option::Some((2, false)),
        Option::Some((3, false)),
        Option::None,
        Option::Some((1, false)),
        Option::Some((1, false)),
        Option::Some((3, false)),
        Option::None,
        Option::Some((2, false)),
        Option::Some((1, false)),
        Option::None,
        Option::Some((1, false)),
        Option::None,
        Option::Some((2, false)),
        Option::None,
        Option::Some((1, false)),
        Option::Some((1, false)),
        Option::Some((2, false)),
        Option::None,
        Option::Some((3, false)),
        Option::Some((5, false)),
        Option::Some((1, false)),
        Option::Some((1, false)),
        Option::Some((1, false)),
        Option::Some((2, false)),
        Option::Some((1, false)),
        Option::None,
        Option::None,
        Option::None,
        Option::None,
        Option::Some((3, false)),
        Option::None,
        Option::Some((2, false)),
        Option::Some((6, false)),
        Option::None,
        Option::None,
        Option::Some((1, false)),
        Option::Some((1, false)),
        Option::Some((2, false)),
        Option::None,
        Option::Some((5, false)),
        Option::None,
        Option::None,
        Option::Some((1, false)),
        Option::Some((1, false)),
        Option::Some((2, false)),
        Option::Some((4, false)),
        Option::Some((3, false)),
        Option::Some((1, false)),
        Option::None,
        Option::None,
        Option::Some((2, false)),
        Option::Some((5, false)),
        Option::Some((7, false)),
        Option::Some((9, false)),
        Option::Some((2, false)),
        Option::Some((4, false)),
        Option::Some((5, false)),
        Option::Some((8, false)),
        Option::Some((1, false)),
        Option::Some((3, false)),
        Option::Some((1, false)),
        Option::Some((6, false)),
        Option::Some((1, false)),
        Option::Some((6, false)),
        Option::Some((8, false)),
        Option::Some((10, false)),

    ];
    // card indices should never exceed u32 size
    *a.at(card_id.try_into().unwrap())
}
