# Oribtum Contracts

## Style guide

### Variable naming

Variables follow this simple naming convention

- `var` : public variable
- `$var` : private variable
- `_var` : scoped variable

## Contracts

### Token (ORBTM)

An ERC20 with 1M supply.

### Donator

A simple address-to-address transfer that takes an extra URI parameter.

Off-chain dApps can follow the `Donate` event and grab the URI associated with each transaction.

### Factory

Factory is a string-to-contract mapping with unique names.

Names are NOT enforced on-chain but can be enforced off-chain by dApps.

### Property

Properties are ERC20 that are 1:1 mapped with ORBTM using `deposit` (mint) and `withdraw` (burn).

Thus, their total supply is the total amount of "staked" ORBTMs. As it is an ERC20, tokens can be transfered.

Properties can be bought by anyone at any moment, similarly to the [Harbeger taxation system](https://medium.com/@simondlr/what-is-harberger-tax-where-does-the-blockchain-fit-in-1329046922c6).

They can also be transfered to anyone by their owner, WITHOUT requiring a payment.

NO fees are set.
