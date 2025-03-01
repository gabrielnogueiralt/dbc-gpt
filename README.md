# InvEvo

## Run example
```sh
python inv_evo/main.py input/ERC20BasicBalances/
```

The contract names must comply with the following convention: the same name of the parent folder, but with the suffix 1 or 2, to show which one is the abstract and the concrete contract. Example: `input/ERC20BasicBalances/ERC20BasicBalances1.sol` is the abstract contract whereas `input/ERC20BasicBalances/ERC20BasicBalances2.sol` is the concrete one.

## Test
```sh
pip install -r requirements.txt
pytest
```
