# Developer Card Smart Contract

Create your own unique developer NFT on the Sui blockchain! This smart contract lets you mint a digital card showcasing your skills, experience, and contact information - think of it as your Web3 business card or developer portfolio that lives on-chain.

## Overview

This project implements a smart contract that allows developers to create and manage their digital profile cards on the Sui blockchain. It's designed as a learning exercise to demonstrate core Move programming concepts including object creation, ownership management, and state modification.

## Project Description

The Developer Card smart contract is a practical implementation that showcases:

- Object creation and management in Move
- Custom data structures
- Object ownership and transfer capabilities
- State modification with proper access controls

## Smart Contract Details

### Module Structure

The `developer_card` module provides functionality to:

- Create new developer cards with personal information
- Update the description of existing cards
- Deactivate a developer card
- Transfer card ownership
- View card details

### Key Functions

#### `init`

- **Description:** Initializes the smart contract by creating the `DeveloperHub` object.
- **Parameters:**
  - `ctx`: Transaction context

#### `createCard`

- **Description:** Creates a new developer card for a developer.
- **Parameters:**
  - `name`: Developer's name (`vector<u8>`)
  - `title`: Developer's title (`vector<u8>`)
  - `img_url`: Developer's image URL (`vector<u8>`)
  - `years_of_exp`: Years of experience (`u8`)
  - `technologies`: Technologies the developer is proficient in (`vector<u8>`)
  - `portfolio`: Developer's portfolio URL (`vector<u8>`)
  - `contact`: Contact information (`vector<u8>`)
  - `payment`: Payment in SUI coins (`Coin<SUI>`)
  - `devhub`: Reference to the `DeveloperHub` object (`&mut DeveloperHub`)
  - `ctx`: Transaction context (`&mut TxContext`)
- **Behavior:**
  - Validates the payment amount.
  - Transfers the payment to the contract owner.
  - Creates a new `DeveloperCard` object with the provided information.
  - Emits a `CardCreatedEvent`.

#### `updateCardDescription`

- **Description:** Updates the description of an existing developer card.
- **Parameters:**
  - `devhub`: Reference to the `DeveloperHub` object (`&mut DeveloperHub`)
  - `new_description`: The new description to set (`vector<u8>`)
  - `id`: The ID of the `DeveloperCard` to update (`u64`)
  - `ctx`: Transaction context (`&mut TxContext`)
- **Behavior:**
  - Ensures the caller is the owner of the card.
  - Updates the card's description.
  - Emits a `CardUpdatedEvent`.

#### `deactivateCard`

- **Description:** Deactivates a developer card, indicating that the developer is no longer open to work.
- **Parameters:**
  - `devhub`: Reference to the `DeveloperHub` object (`&mut DeveloperHub`)
  - `id`: The ID of the `DeveloperCard` to deactivate (`u64`)
  - `ctx`: Transaction context (`&mut TxContext`)
- **Behavior:**
  - Ensures the caller is the owner of the card.
  - Sets the `open_to_work` flag to `false`.

#### `getCard`

- **Description:** Retrieves the details of a developer card.
- **Parameters:**
  - `devhub`: Reference to the `DeveloperHub` object (`&DeveloperHub`)
  - `id`: The ID of the `DeveloperCard` to retrieve (`u64`)
- **Returns:**
  - A tuple containing the card's details:
    - `name`: `String`
    - `owner`: `address`
    - `title`: `String`
    - `img_url`: `Url`
    - `description`: `Option<String>`
    - `years_of_experience`: `u8`
    - `technologies`: `String`
    - `portfolio`: `String`
    - `contact`: `String`
    - `open_to_work`: `bool`

## Usage

The smart contract is deployed on the Sui devnet network with the following package ID:

```
0xb604cedfd41874421a1caf4b9b980f6ce68f7ab29f61e5699f46c9da5fcb3cd1
```

### Creating a Developer Card

To create a new developer card, call the `createCard` function with the necessary parameters and the required payment.

### Updating Card Description

To update the description of your developer card, call the `updateCardDescription` function with the new description and your card ID.

### Deactivating a Card

If you are no longer open to work, you can deactivate your card by calling the `deactivateCard` function with your card ID.

### Retrieving Card Details

To view the details of a developer card, use the `getCard` function with the card's ID.

## Events

### `CardCreatedEvent`

Emitted when a new developer card is created.

### `CardUpdatedEvent`

Emitted when a developer card's description is updated.
