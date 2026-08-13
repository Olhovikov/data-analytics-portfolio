DROP TABLE IF EXISTS sales_transactions;

CREATE TABLE sales_transactions (
    row_id            text PRIMARY KEY,
    transaction_id    text NOT NULL,
    sale_date          date NOT NULL,
    sale_time          time,
    sku                text NOT NULL,
    product_name       text NOT NULL,
    category           text,
    location           text NOT NULL,
    channel            text NOT NULL CHECK (channel IN ('Retail', 'Wholesale')),
    unit               text,
    quantity           numeric(14,3) NOT NULL,
    gross_revenue      numeric(14,4) NOT NULL,
    net_revenue        numeric(14,4) NOT NULL,
    vat                numeric(14,4) NOT NULL,
    cost               numeric(14,4) NOT NULL,
    gross_profit       numeric(14,4) NOT NULL,
    discount_amount    numeric(14,4) NOT NULL,
    discount_pct       numeric(8,4) NOT NULL,
    is_return          boolean NOT NULL
);

CREATE INDEX idx_sales_date ON sales_transactions (sale_date);
CREATE INDEX idx_sales_sku ON sales_transactions (sku);
CREATE INDEX idx_sales_location ON sales_transactions (location);
CREATE INDEX idx_sales_transaction ON sales_transactions (transaction_id);

-- The published sample CSV uses the same column order and the headers sale_date/sale_time,
-- so it can be imported directly with pgAdmin's Import/Export Data dialog.
