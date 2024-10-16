# ДЗ 1 Царахова Милена БПИ213

## Контракты

Все контракты находятся в папке contracts. 
Тесты написаны в файле test/ERC20Test.js. Запускается через `npx hardhat test`
Контракты задеплоены в тестовой сети. В тестовой сети можно задеплоить запустив команду `npx hardhat run scripts/MilenaTssERC20.js --network sepolia`. Также можно сделать локальную сеть командой `npx hardhat node` и выполнить деплой командой `npx hardhat run scripts/MilenaTssERC20.js --network local`.

Скрипт просмотра storage: `scripts/storage_view.js`. Скрипт с примерами вызова функций контракта: `scripts/tokens_example.js`. Запуск скрипта : `npx hardhat run scripts/tokens_example.js --network local`. Скрипт для нахождения событий: `scripts/events.js`.

Адрес кошелька - `0xa2b1D6AF982746Cf3E6B2104c017C7a336f332a7` в тестовой сети Sepolia. Все действия по [ссылке](https://sepolia.etherscan.io/address/0xa2b1D6AF982746Cf3E6B2104c017C7a336f332a7)

![Sepolia token](./images/sepolia_token.png) ![Sepolia nft](./images/sepolia_nft_721.png)

![Local token](./images/local_token.png)


## Вопросы по стандартам ERC20, ERC721, ERC1155

1. Что такое функция approve и как она используется?  
   Функция `approve` в ERC20 позволяет владельцу токенов разрешить другому адресу (спендеру) потратить определенное количество его токенов. Используется для делегирования прав на перевод токенов через `transferFrom`.

2. В чем различие ERC721 и ERC1155?  
   ERC721 — стандарт для уникальных токенов (NFT), каждый токен уникален. ERC1155 — поддерживает как уникальные (NFT), так и одинаковые (Fungible) токены в одном контракте.

3. Что такое SBT токен?  
   SBT (Soulbound Token) — это непередаваемый токен, привязанный к владельцу на постоянной основе. Он не может быть продан или передан.

4. Как можно сделать SBT токен?  
   Создать SBT можно через модификацию ERC721 или ERC1155, где в функции `transfer` добавляется проверка, запрещающая передачу токена.