# Power BI model specification

## Tables

- `Fact Sales`: transaction-level numeric facts
- `Dim Product`: one row per anonymized SKU
- `Dim Location`: one row per store or warehouse, including channel
- `Dim Date`: continuous calendar from 2025-05-01 to 2026-07-31

## Relationships

| From | To | Cardinality | Filter direction |
|---|---|---|---|
| `Dim Date[date]` | `Fact Sales[date]` | One-to-many | Single |
| `Dim Product[sku]` | `Fact Sales[sku]` | One-to-many | Single |
| `Dim Location[location]` | `Fact Sales[location]` | One-to-many | Single |

Do not create fact-to-fact relationships. Disable automatic date/time and mark `Dim Date[date]` as the date table. Sort `Dim Date[month]` by `month_number`, `day_of_week` by `day_of_week_number`, and use `year_month` on time-series axes.

## Data types

- Date: `date`
- Decimal number: quantity, revenue, VAT, cost, profit, discounts, discount percentage
- True/False: `is_return`, `is_weekend`
- Text: IDs, time, channel, category, unit

