class FaqItems {
  static const Map<String,String> map = {
    "How much wallet I can create?"
        : "There is no limit! You can create as many wallets as you want.\n",
    "What is seed/keys?"
        : "Your keys encode the private information in your wallet, and are what allow "
        "you to spend coins and see incoming transactions.\n"
        "Your seed is just a version of your private key written in a way that’s easier "
        "for you to write down. Your seed and keys are actually the same thing, just in different forms!\n"
        "DO NOT ever give your seed or keys to anyone. Your funds will be stolen if you give anyone "
        "your seed or keys. Please write down your seed, however, and store it in a safe place "
        "(this will allow you to restore your wallet if you lose your phone.)\n",
    "How can I restore wallet?"
        : "Tap the ••• menu, select “Wallets”, and then choose “Restore Wallet.” Then enter your seed "
        "(or your keys), and optionally enter a date before the first transaction in your wallet "
        "(this will speed up the syncing process.) You may need to keep the app open for "
        "15-30 minutes in order to completely restore your wallet.\n",
    "What I need to do if I forgot my seed/keys?"
        : "If you forgot your seed, you likely wrote it down somewhere. Please check your "
        "iCloud notes and look around on your computer. If you can’t find it anywhere, you "
        "may have backed up Cake Wallet to iCloud (in which case you would be able to restore "
        "from that backup.) If none of these work, there is unfortunately nothing that we can do.\n",
    "What’s the difference between Available Balance and Full Balance?"
        : "After you make a transaction or receive some Monero, the transaction still needs to be confirmed. "
        "In about 20 minutes your “available balance” should update! Sometimes, when you send Monero, "
        "your available balance will decrease by more than the amount you’ve sent. This is normal, and "
        "it’s necessary in order to protect your privacy. Your “full balance” should be back to normal in 20 minutes.\n",
    "How do I send Monero to an exchange that requires a Payment ID?"
        : "Tap the “send” button on the Wallet screen. Next, copy the exchange’s deposit address and "
        "paste it into the “address” box. Then, copy the Payment ID provided by the exchange and paste "
        "it into the Payment ID box. Finally, enter the amount you’d like to send, and you’re good to go!\n",
    "What do I do if I forgot to enter the Payment ID when sending Monero to an exchange?"
        : "While our support can’t directly help you with this issue, it’s a very common problem that "
        "most exchanges are used to dealing with. Just contact the exchange’s support, explain that "
        "you forgot to include your Payment ID, and then send them your Transaction ID as proof. "
        "You can find the Transaction ID by tapping on the transaction in your Wallet screen.\n",
    "Do you save information about my wallet?"
        : "Cake Wallet DOES NOT collect or record any information about your wallet. We care about your privacy.\n",
    "I sent money to another wallet, can I return it back?"
        : "Unfortunately, as soon as a transaction has been submitted to the blockchain, there is no way "
        "to undo it. You can always cancel the transaction before it’s sent though, so always double-check "
        "the address before you send a transaction.\n",
    "Can I add wallet for another cryptocurrency?"
        : "Not yet... This is a planned feature, though!\n"
  };
}