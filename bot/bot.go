package bot

import (
    "log"
    "os"
    "time"

    tele "gopkg.in/telebot.v4"
)

func Start() {
    token := os.Getenv("TELE_TOKEN")
    if token == "" {
        log.Fatal("TELE_TOKEN is not set")
    }

    bot, err := tele.NewBot(tele.Settings{
        Token:  token,
        Poller: &tele.LongPoller{Timeout: 10 * time.Second},
    })

    if err != nil {
        log.Fatal(err)
    }

    // Handler for text messages
    bot.Handle(tele.OnText, func(c tele.Context) error {
        return c.Send("Ти написав: " + c.Text())
    })

    // Handler for /start
    bot.Handle("/start", func(c tele.Context) error {
        return c.Send("Привіт! Я бот на Go. Напиши мені щось.")
    })

    // Handler for /help
    bot.Handle("/help", func(c tele.Context) error {
        return c.Send("Доступні команди:\n/start\n/help")
    })

    bot.Start()
}
