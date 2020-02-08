module Constants

using Dates

export LEVEL, MAX_TRADES, DATE_FROM, UP_TICKS

LEVEL = 100

MAX_TRADES = 50

DATE_FROM = Dates.format(
    Dates.today() - Dates.Week(1), 
    "Y-mm-dd"
)

UP_TICKS = ("PlusTick", "ZeroPlusTick")

end
