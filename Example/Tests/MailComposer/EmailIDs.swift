//
//  EmailIDs.swift
//  TestTests
//
//  Created by Sauvik Dolui on 20/02/19.
//  Copyright © 2019 Sauvik Dolui. All rights reserved.
//

import Foundation

let validEmails = [
    "simple@example.com",
    "very.common@example.com",
    "disposable.style.email.with+symbol@example.com",
    "other.email-with-hyphen@example.com",
    "fully-qualified-domain@example.com",
    "user.name+tag+sorting@example.com",
    "x@example.com",
    "example-indeed@strange-example.com",
    "admin@mailserver1.com",
    "example@s.example",
    "admin@example.co.uk",
    "admin@example.co.uk.lastdomain",
    "example@example.org",
    "_@a.c",
    "abc..abc@domain.com",
    "abc__abc@domain.com",
    "abc__@domain.com",
    "abc+@domain.com",
    "ABC.ABC.ABC.ABC0046@domain.com.com.com"
]

let invalidEmails = [
    "abc@@insta.com.com.com",
    "abc@insta..com",
    "abc@insta%.com",
    "abc@insta/.com",
    "abc@insta\\.com",
    "abc.@insta.com",
    "abc\\@insta.com",
    "abc@insta-.com",
]
