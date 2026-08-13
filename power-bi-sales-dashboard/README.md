# Power BI sales dashboard

This folder contains the data model and measures I prepared for the Power BI version of the sales analysis.

![Dashboard layout](images/dashboard-preview.png)

## Included

- `data/fact_sales_sample.csv`
- `data/dim_date.csv`
- `data/dim_product.csv`
- `data/dim_location.csv`
- `powerbi/measures.dax`
- `powerbi/model.md`
- `powerbi/build-guide.md`

## Setup

1. Import the four CSV files.
2. Rename the queries to `Fact Sales`, `Dim Date`, `Dim Product` and `Dim Location`.
3. Create the relationships shown in `powerbi/model.md`.
4. Mark `Dim Date[date]` as the date table.
5. Add the measures from `powerbi/measures.dax`.
6. Use `powerbi/build-guide.md` as a page checklist.

I use Retail as the default filter and keep Wholesale on a separate page. The warehouse has only a small number of large invoices, so combining the two channels would make the retail average receipt almost meaningless.

The repository does not include a `.pbix` file because it still needs to be created and checked in Power BI Desktop.

The published fact table is a 5,000-row anonymized sample covering every month, location and channel. The preview and reported findings were prepared from the full 154,695-row dataset.
