package cmd

import (
    "fmt"
    "os"

    "github.com/kylib4444/kbot/bot"
    "github.com/spf13/cobra"
)

var rootCmd = &cobra.Command{
    Use:   "kbot",
    Short: "Simple Telegram bot written in Go",
    Run: func(cmd *cobra.Command, args []string) {
        fmt.Println("Starting Telegram bot...")
        bot.Start()
    },
}

func Execute() {
    if err := rootCmd.Execute(); err != nil {
        fmt.Println(err)
        os.Exit(1)
    }
}
