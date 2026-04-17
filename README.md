# Telegram Bot on Go (kbot)

Цей проєкт — Telegram‑бот, написаний на Golang з використанням:

- `gopkg.in/telebot.v4`
- `github.com/spf13/cobra`

Запуск

1. Встановити залежності
go mod tidy
2. Додати токен бота
export TELE_TOKEN="your_bot_token"
3. Запустити
go run main.go

Команди бота
- `/start` — привітання
- `/help` — список команд
- текстові повідомлення — бот повторює текст

Посилання на бота
t.me/kylib_bot


