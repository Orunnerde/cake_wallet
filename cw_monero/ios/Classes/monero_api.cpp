#include <stdint.h>
#include "cstdlib"
#include <chrono>
#include <functional>
#include <iostream>
#include "thread"
#include "../External/android/monero/include/wallet2_api.h"
#include "CwWalletListener.h"

using namespace std::chrono_literals;

#ifdef __cplusplus
extern "C"
{
#endif

    struct SubaddressRow
    {
        uint64_t id;
        char *address;
        char *label;

        SubaddressRow(std::size_t _id, char *_address, char *_label)
        {
            id = static_cast<uint64_t>(_id);
            address = _address;
            label = _label;
        }
    };

    struct AccountRow
    {
        uint64_t id;
        char *label;

        AccountRow(std::size_t _id, char *_label)
        {
            id = static_cast<uint64_t>(_id);
            label = _label;
        }
    };

    struct MoneroWalletListener : Monero::WalletListener
    {
        uint64_t m_height;
        bool m_need_to_refresh;
        bool m_new_transaction;

        MoneroWalletListener()
        {
            m_height = 0;
            m_need_to_refresh = false;
        }

        void moneySpent(const std::string &txId, uint64_t amount)
        {
            m_new_transaction = true;
        }

        void moneyReceived(const std::string &txId, uint64_t amount)
        {
            m_new_transaction = true;
        }

        void unconfirmedMoneyReceived(const std::string &txId, uint64_t amount)
        {
            m_new_transaction = true;
        }

        void newBlock(uint64_t height)
        {
            m_height = height;
        }

        void updated()
        {
            m_need_to_refresh = true;
        }

        void refreshed()
        {
            m_need_to_refresh = true;
        }

        void resetNeedToRefresh()
        {
            m_need_to_refresh = false;
        }

        bool isNeedToRefresh()
        {
            return m_need_to_refresh;
        }

        bool isNewTransactionExist()
        {
            return m_new_transaction;
        }

        void resetIsNewTransactionExist()
        {
            m_new_transaction = false;
        }

        uint64_t height()
        {
            return m_height;
        }
    };

    struct TransactionInfoRow
    {
        uint64_t amount;
        uint64_t fee;
        uint64_t blockHeight;
        uint32_t subaddrAccount;
        uint64_t confirmations;
        uint64_t datetime;
        int direction;
        bool isPending;
        char *hash;
        char *paymentId;

        TransactionInfoRow(Monero::TransactionInfo *transaction)
        {
            amount = transaction->amount();
            fee = transaction->fee();
            blockHeight = transaction->blockHeight();
            subaddrAccount = transaction->subaddrAccount();
            confirmations = transaction->confirmations();
            datetime = transaction->timestamp();
            direction = transaction->direction();
            isPending = transaction->isPending();
            std::string *hash_str = new std::string(transaction->hash());
            hash = strdup(hash_str->c_str());
            paymentId = strdup(transaction->paymentId().c_str());
        }
    };

    struct PendingTransactionRaw
    {
        uint64_t amount;
        uint64_t fee;
        char *hash;
        Monero::PendingTransaction *transaction;

        PendingTransactionRaw(Monero::PendingTransaction *_transaction)
        {
            transaction = _transaction;
            amount = _transaction->amount();
            fee = _transaction->fee();
            hash = strdup(_transaction->txid()[0].c_str());
        }
    };

    Monero::Wallet *m_wallet;
    Monero::TransactionHistory *m_transaction_history;
    MoneroWalletListener *m_listener;
    Monero::Subaddress *m_subaddress;
    Monero::SubaddressAccount *m_account;
    uint64_t m_last_known_wallet_height;

    void change_current_wallet(Monero::Wallet *wallet)
    {
        m_wallet = wallet;

        if (wallet != nullptr)
        {
            m_transaction_history = wallet->history();
        }
        else
        {
            m_transaction_history = nullptr;
        }

        if (wallet != nullptr)
        {
            m_account = wallet->subaddressAccount();
        }
        else
        {
            m_account = nullptr;
        }

        if (wallet != nullptr)
        {
            m_subaddress = wallet->subaddress();
        }
        else
        {
            m_subaddress = nullptr;
        }
    }

    Monero::Wallet *get_current_wallet()
    {
        return m_wallet;
    }

    bool create_wallet(char *path, char *password, char *language, int32_t networkType, char *error)
    {
        Monero::NetworkType _networkType = static_cast<Monero::NetworkType>(networkType);
        Monero::WalletManager *walletManager = Monero::WalletManagerFactory::getWalletManager();
        Monero::Wallet *wallet = walletManager->createWallet(path, password, language, _networkType);

        int status;
        std::string errorString;

        wallet->statusWithErrorString(status, errorString);

        if (status != Monero::Wallet::Status_Ok)
        {
            error = strdup(errorString.c_str());
            return false;
        }

        change_current_wallet(wallet);

        return true;
    }

    bool restore_wallet_from_seed(char *path, char *password, char *seed, int32_t networkType, uint64_t restoreHeight, char *error)
    {
        Monero::NetworkType _networkType = static_cast<Monero::NetworkType>(networkType);
        Monero::Wallet *wallet = Monero::WalletManagerFactory::getWalletManager()->recoveryWallet(
            std::string(path),
            std::string(password),
            std::string(seed),
            _networkType,
            (uint64_t)restoreHeight);

        int status;
        std::string errorString;

        wallet->statusWithErrorString(status, errorString);

        if (status != Monero::Wallet::Status_Ok)
        {
            error = strdup(errorString.c_str());
            return false;
        }

        change_current_wallet(wallet);
        return true;
    }

    bool restore_wallet_from_keys(char *path, char *password, char *language, char *address, char *viewKey, char *spendKey, int32_t networkType, uint64_t restoreHeight, char *error)
    {
        Monero::NetworkType _networkType = static_cast<Monero::NetworkType>(networkType);
        Monero::Wallet *wallet = Monero::WalletManagerFactory::getWalletManager()->createWalletFromKeys(
            std::string(path),
            std::string(password),
            std::string(language),
            _networkType,
            (uint64_t)restoreHeight,
            std::string(address),
            std::string(viewKey),
            std::string(spendKey));

        int status;
        std::string errorString;

        wallet->statusWithErrorString(status, errorString);

        if (status != Monero::Wallet::Status_Ok)
        {
            error = strdup(errorString.c_str());
            return false;
        }

        change_current_wallet(wallet);
        return true;
    }

    void load_wallet(char *path, char *password, int32_t nettype)
    {
        Monero::NetworkType networkType = static_cast<Monero::NetworkType>(nettype);
        Monero::Wallet *wallet = Monero::WalletManagerFactory::getWalletManager()->openWallet(std::string(path), std::string(password), networkType);
        change_current_wallet(wallet);
    }

    bool is_wallet_exist(char *path)
    {
        return Monero::WalletManagerFactory::getWalletManager()->walletExists(std::string(path));
    }

    void close_current_wallet()
    {
        Monero::WalletManagerFactory::getWalletManager()->closeWallet(get_current_wallet());
        change_current_wallet(nullptr);
    }

    char *get_filename()
    {
        return strdup(get_current_wallet()->filename().c_str());
    }

    char *secret_view_key()
    {
        return strdup(get_current_wallet()->secretViewKey().c_str());
    }

    char *public_view_key()
    {
        return strdup(get_current_wallet()->publicViewKey().c_str());
    }

    char *secret_spend_key()
    {
        return strdup(get_current_wallet()->secretSpendKey().c_str());
    }

    char *public_spend_key()
    {
        return strdup(get_current_wallet()->publicSpendKey().c_str());
    }

    char *get_address(uint32_t account_index, uint32_t address_index)
    {
        return strdup(get_current_wallet()->address(account_index, address_index).c_str());
    }


    const char *seed()
    {
        return strdup(get_current_wallet()->seed().c_str());
    }

    uint64_t get_full_balance(uint32_t account_index)
    {
        return get_current_wallet()->balance(account_index);
    }

    uint64_t get_unlocked_balance(uint32_t account_index)
    {
        return get_current_wallet()->unlockedBalance(account_index);
    }

    uint64_t get_current_height()
    {
        return get_current_wallet()->blockChainHeight();
    }

    uint64_t get_node_height()
    {
        return get_current_wallet()->daemonBlockChainHeight();
    }

    bool setup_node(char *address, char *login, char *password, bool use_ssl, bool is_light_wallet, char *error)
    {
        Monero::Wallet *wallet = get_current_wallet();
        std::string _login = "";
        std::string _password = "";

        if (login != nullptr)
        {
            _login = std::string(login);
        }

        if (password != nullptr)
        {
            _password = std::string(password);
        }

        bool inited = wallet->init(std::string(address), 0, _login, _password, use_ssl, is_light_wallet);

        if (!inited)
        {
            error = strdup(wallet->errorString().c_str());
            return false;
        }
        else
        {
            wallet->setTrustedDaemon(true);
        }

        return inited;
    }

    bool connect_to_node(char *error)
    {
        bool is_connected = get_current_wallet()->connectToDaemon();

        if (!is_connected)
        {
            error = strdup(get_current_wallet()->errorString().c_str());
        }

        return is_connected;
    }

    bool is_connected()
    {
        return get_current_wallet()->connected();
    }

    void start_refresh()
    {
        get_current_wallet()->refreshAsync();
        get_current_wallet()->startRefresh();
    }

    void set_refresh_from_block_height(uint64_t height)
    {
        get_current_wallet()->setRefreshFromBlockHeight(height);
    }

    void set_recovering_from_seed(bool is_recovery)
    {
        get_current_wallet()->setRecoveringFromSeed(is_recovery);
    }

    void store(char *path)
    {
        get_current_wallet()->store(std::string(path));
    }

    PendingTransactionRaw *transaction_create(char *address, char *payment_id, char *amount,
                                                  uint8_t priority_raw, uint32_t subaddr_account, char *error)
        {
            auto priority = static_cast<Monero::PendingTransaction::Priority>(priority_raw);
            std::string _payment_id;
            Monero::PendingTransaction *transaction;

            if (payment_id != nullptr)
            {
                _payment_id = std::string(payment_id);
            }

            if (amount != nullptr)
            {
                uint64_t _amount = Monero::Wallet::amountFromString(std::string(amount));
                transaction = m_wallet->createTransaction(std::string(address), _payment_id, _amount, m_wallet->defaultMixin(), priority, subaddr_account);
            }
            else
            {
                transaction = m_wallet->createTransaction(std::string(address), _payment_id, Monero::optional<uint64_t>(), m_wallet->defaultMixin(), priority, subaddr_account);
            }

            int status = transaction->status();

            if (status == Monero::PendingTransaction::Status::Status_Error || status == Monero::PendingTransaction::Status::Status_Critical)
            {
                error = strdup(transaction->errorString().c_str());
                return nullptr;
            }

            return new PendingTransactionRaw(transaction);
        }

    bool transaction_commit(PendingTransactionRaw *transaction, char *error)
    {
        bool committed = transaction->transaction->commit();

        if (!committed)
        {
            error - strdup(transaction->transaction->errorString().c_str());
        }

        return committed;
    }

    uint64_t get_syncing_height()
    {
        uint64_t _height = m_listener->height();

        if (_height != m_last_known_wallet_height)
        {
            m_last_known_wallet_height = _height;
        }

        return _height;
    }

    uint64_t is_needed_to_refresh()
    {
        bool should_refresh = m_listener->isNeedToRefresh();

        if (should_refresh)
        {
            m_listener->resetNeedToRefresh();
        }

        return should_refresh;
    }

    uint8_t is_new_transaction_exist()
    {

        bool is_new_transaction_exist = m_listener->isNewTransactionExist();

        if (is_new_transaction_exist)
        {
            m_listener->resetIsNewTransactionExist();
        }

        return is_new_transaction_exist;
    }

    void set_listener()
    {
        m_last_known_wallet_height = 0;

        if (m_listener != nullptr)
        {
            free(m_listener);
        }

        m_listener = new MoneroWalletListener();
        get_current_wallet()->setListener(m_listener);
    }

    int64_t *subaddrress_get_all()
    {
        std::vector<Monero::SubaddressRow *> _subaddresses = m_subaddress->getAll();
        size_t size = _subaddresses.size();
        int64_t *subaddresses = (int64_t *)malloc(size * sizeof(int64_t));

        for (int i = 0; i < size; i++)
        {
            Monero::SubaddressRow *row = _subaddresses[i];
            SubaddressRow *_row = new SubaddressRow(row->getRowId(), strdup(row->getAddress().c_str()), strdup(row->getLabel().c_str()));
            subaddresses[i] = reinterpret_cast<int64_t>(_row);
        }

        return subaddresses;
    }

    int32_t subaddrress_size()
    {
        std::vector<Monero::SubaddressRow *> _subaddresses = m_subaddress->getAll();
        return _subaddresses.size();
    }

    void subaddress_add_row(uint32_t accountIndex, char *label)
    {
        m_subaddress->addRow(accountIndex, std::string(label));
    }

    void subaddress_set_label(uint32_t accountIndex, uint32_t addressIndex, char *label)
    {
        m_subaddress->setLabel(accountIndex, addressIndex, std::string(label));
    }

    void subaddress_refresh(uint32_t accountIndex)
    {
        m_subaddress->refresh(accountIndex);
    }

    int32_t account_size()
    {
        std::vector<Monero::SubaddressAccountRow *> _accocunts = m_account->getAll();
        return _accocunts.size();
    }

    int64_t *account_get_all()
    {
        std::vector<Monero::SubaddressAccountRow *> _accocunts = m_account->getAll();
        size_t size = _accocunts.size();
        int64_t *accocunts = (int64_t *)malloc(size * sizeof(int64_t));

        for (int i = 0; i < size; i++)
        {
            Monero::SubaddressAccountRow *row = _accocunts[i];
            AccountRow *_row = new AccountRow(row->getRowId(), strdup(row->getLabel().c_str()));
            accocunts[i] = reinterpret_cast<int64_t>(_row);
        }

        return accocunts;
    }

    void account_add_row(char *label)
    {
        m_account->addRow(std::string(label));
    }

    void account_set_label_row(uint32_t account_index, char *label)
    {
        m_account->setLabel(account_index, label);
    }

    void account_refresh()
    {
        m_account->refresh();
    }

    int64_t *transactions_get_all()
    {
        std::vector<Monero::TransactionInfo *> transactions = m_transaction_history->getAll();
        size_t size = transactions.size();
        int64_t *transactionAddresses = (int64_t *)malloc(size * sizeof(int64_t));

        for (int i = 0; i < size; i++)
        {
            Monero::TransactionInfo *row = transactions[i];
            TransactionInfoRow *tx = new TransactionInfoRow(row);
            transactionAddresses[i] = reinterpret_cast<int64_t>(tx);
        }

        return transactionAddresses;
    }

    void transactions_refresh()
    {
        m_transaction_history->refresh();
    }

    int64_t transactions_count()
    {
        return m_transaction_history->count();
    }

    int LedgerExchange(
        unsigned char *command,
        unsigned int cmd_len,
        unsigned char *response,
        unsigned int max_resp_len)
    {
        return -1;
    }

    int LedgerFind(char *buffer, size_t len)
    {
        return -1;
    }

#ifdef __cplusplus
}
#endif
