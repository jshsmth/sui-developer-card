module smart_contract::developer_card {
    use std::string::{Self, String};
    use sui::url::{Self, Url};
    use sui::object_table::{Self, ObjectTable};
    use sui::coin::{Self, Coin};
    use sui::sui::{SUI};
    use sui::event;

    const NOT_THE_OWNER: u64 = 0;
    const INSUFFICIENT_FUNDS: u64 = 1;
    const MIN_CARD_COST: u64 = 1;

    public struct DeveloperCard has key, store {
        id: UID,
        name: String,
        owner: address,
        title: String,
        img_url: Url,
        description: Option<String>,
        years_of_experience: u8,
        technologies: String,
        portfolio: String,
        contact: String,
        open_to_work: bool,
    }

    public struct DeveloperHub has key {
        id: UID,
        owner: address,
        counter: u64,
        cards: ObjectTable<u64, DeveloperCard>,
    }

    public struct CardCreatedEvent has copy, drop {
        id: ID,
        name: String,
        owner: address,
        title: String,
        contact: String,
    }

    public struct CardUpdatedEvent has copy, drop {
        name: String,
        owner: address,
        title: String,
        new_description: String,
    }

    public struct PortfolioUpdatedEvent has copy, drop {
        name: String,
        owner: address,
        title: String,
        new_portfolio: String,
    }

    //==================INITIALIZE CONTRACT=======================//
    fun init(ctx: &mut TxContext) {
        transfer::share_object(
            DeveloperHub {
                id: object::new(ctx),
                owner: tx_context::sender(ctx),
                counter: 0,
                cards: object_table::new(ctx),
            }
        );
    }

    //==================CREATE CARD============================//
    public entry fun createCard(
        name: vector<u8>,
        title: vector<u8>,
        img_url: vector<u8>,
        years_of_exp: u8,
        technologies: vector<u8>,
        portfolio: vector<u8>,
        contact: vector<u8>,
        payment: Coin<SUI>,
        devhub: &mut DeveloperHub,
        ctx: &mut TxContext
    ) {
        let value = coin::value(&payment);
        assert!(value == MIN_CARD_COST, INSUFFICIENT_FUNDS);
        transfer::public_transfer(payment, devhub.owner);

        devhub.counter = devhub.counter + 1;

        let id = object::new(ctx);

        event::emit(
            CardCreatedEvent {
                id: object::uid_to_inner(&id),
                name: string::utf8(name),
                owner: tx_context::sender(ctx),
                title: string::utf8(title),
                contact: string::utf8(contact),
            }
        );

        let devcard = DeveloperCard {
            id: id,
            name: string::utf8(name),
            owner: tx_context::sender(ctx),
            title: string::utf8(title),
            img_url: url::new_unsafe_from_bytes(img_url),
            description: option::none(),
            years_of_experience: years_of_exp,
            technologies: string::utf8(technologies),
            portfolio: string::utf8(portfolio),
            contact: string::utf8(contact),
            open_to_work: true,
        };

      
        object_table::add(&mut devhub.cards, devhub.counter, devcard);
    }

    //==================UPDATE CARD============================//
    public entry fun updateCardDescription(
        devhub: &mut DeveloperHub,
        new_description: vector<u8>,
        id: u64,
        ctx: &mut TxContext
    ) {
        let user_card = object_table::borrow_mut(&mut devhub.cards, id);
        assert!(tx_context::sender(ctx) == user_card.owner, NOT_THE_OWNER);
        let old_value = option::swap_or_fill(&mut user_card.description, string::utf8(new_description));

        event::emit(CardUpdatedEvent {
            name: user_card.name,
            owner: user_card.owner,
            title: user_card.title,
            new_description: string::utf8(new_description),
        });

        _ = old_value;
    }

    //==================DEACTIVATE CARD============================//
    public entry fun deactivateCard(
        devhub: &mut DeveloperHub,
        id: u64,
        ctx: &mut TxContext
    ) {
        let card = object_table::borrow_mut(&mut devhub.cards, id);
        assert!(card.owner == tx_context::sender(ctx), NOT_THE_OWNER);
        card.open_to_work = false;
    }

    //==================GET CARD============================//
    public fun getCard(
        devhub: &DeveloperHub,
        id: u64
    ): (
        String,
        address,
        String,
        Url,
        Option<String>,
        u8,
        String,
        String,
        String,
        bool,
    ) {
        let card = object_table::borrow(&devhub.cards, id);
        (
            card.name,
            card.owner,
            card.title,
            card.img_url,
            card.description,
            card.years_of_experience,
            card.technologies,
            card.portfolio,
            card.contact,
            card.open_to_work,
        )
    }

    //==================UPDATE PORTFOLIO============================//
    public entry fun updatePortfolio(
        devhub: &mut DeveloperHub,
        id: u64,
        new_portfolio: vector<u8>,
        ctx: &mut TxContext
    ) {
        let card = object_table::borrow_mut(&mut devhub.cards, id);
        assert!(card.owner == tx_context::sender(ctx), NOT_THE_OWNER);
        card.portfolio = string::utf8(new_portfolio);

        event::emit(PortfolioUpdatedEvent {
            name: card.name,
            owner: card.owner,
            title: card.title,
            new_portfolio: string::utf8(new_portfolio),
        });
    }
}
