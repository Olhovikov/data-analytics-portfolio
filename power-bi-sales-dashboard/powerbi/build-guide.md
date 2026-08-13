# Page checklist

## Visual style

- Canvas: 16:9, light grey page background (`#F3F5F9`)
- Cards and visual containers: white, subtle light-grey border, no shadow
- Primary accent: cobalt blue (`#2F5BEA`); dark blue (`#1D3F9F`) for titles
- Comparison accent: amber (`#F59E0B`) for gross profit; muted red only for returns
- Font: Segoe UI; titles 12–14 pt, KPI values 26–32 pt
- Keep the filter row at the top, KPI cards below it and six aligned visuals underneath
- Import `theme.json` before formatting the page

## 1. Retail overview

- Page filter: channel = Retail
- KPI cards: Revenue, Gross Profit, Gross Margin %, Transactions, Average Basket
- Donut chart: Revenue by Store
- Bar chart: Gross Profit by Store
- Donut chart: regular-price, discounted and returned revenue
- Bar charts: Top 5 Products and Top 5 Categories by Revenue
- Combo chart: year-month with Revenue columns and Gross Profit line
- Slicers: date, location, category; add a blue Retail Overview navigation button

## 2. Products

- Bar chart: top 15 products by Revenue
- Matrix: category and product with Revenue, Gross Profit, Margin %, Units, Revenue Share %
- Scatter chart: Units vs Gross Margin %, bubble size = Revenue
- Slicers: ABC/XYZ segment can be added by importing `product_segments.csv` from the SQL project

## 3. Discounts and returns

- KPI cards: Discount Value, Discount to Revenue %, Returned Value, Return Rate %
- Column chart: discount percentage band vs Revenue and Gross Profit
- Table: products ranked by Returned Value
- Trend: Return Rate % by year-month

## 4. Wholesale

- Page filter: channel = Wholesale
- KPI cards: Revenue, Gross Profit, Transactions, Average Basket
- Keep this page separate from retail because wholesale has few high-value transactions.

Use the PNG only as a layout reference. A light background, dark grey text and one muted blue accent are enough; keep warning colours for returns or negative changes.
