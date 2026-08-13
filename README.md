# Danila Olhovikov - Data Analytics Portfolio

Hi, I’m Danila. I work with sales and inventory reports in retail and built these projects to turn routine monthly exports into information that is easier to use.

The source covers 15 months. Before the analysis, I removed personal and commercial identifiers, checked product codes and dates, separated retail from wholesale, and fixed repeated inventory rows. The full analysis uses 154,695 sales lines. This repository includes smaller anonymized samples so the projects are easy to download and review.

![Sales overview](sales-analysis-sql/images/dashboard.png)

## Projects

### [Sales analysis with SQL](sales-analysis-sql/)

PostgreSQL queries and an Excel workbook for revenue, profit, average receipt, stores, products, discounts and returns. I also added ABC/XYZ segmentation to compare product contribution with demand stability.

### [Inventory forecast](inventory-forecast/)

An Excel model that compares recent demand with current stock and produces a review list for each product and store. The assumptions are visible and editable.

### [Power BI sales dashboard](power-bi-sales-dashboard/)

A Power BI-ready star schema, DAX measures and a short build guide. The report keeps wholesale on a separate page because a few large warehouse invoices distort retail KPIs.

## A few findings

- Retail revenue in May–July 2026 was 22.4% lower than in the same months of 2025.
- Full-period gross margin was 35.3%.
- Store C generated 40.8% of retail revenue.
- December was the strongest month in the dataset.
- During inventory cleaning, I found 5,475 repeated rows linked to alternative supplier records. Summing them would have overstated inventory value by about 9%.

## Data note

The published data is anonymized. Names of products, stores, suppliers, employees and customers were removed or replaced, and monetary values were transformed consistently. Ratios and trends were preserved.

The CSV files ending in `_sample.csv` are reproducible review samples. The Excel results and findings were calculated from the full cleaned dataset, not from the samples alone.

The stock-order model is a prototype. Supplier receipts, transfers, write-offs, pack sizes, minimum orders and actual lead times were not available, so its output should be treated as a review list rather than a purchase order.
