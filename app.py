from pathlib import Path

import pandas as pd
import streamlit as st


DATA_FILE = Path(__file__).resolve().with_name("Customer_Data.csv")
REQUIRED_COLUMNS = {
    "customer_id",
    "contract",
    "payment_method",
    "state",
    "customer_status",
    "monthly_charge",
    "churn_reason",
}


@st.cache_data
def load_data() -> pd.DataFrame:
    if not DATA_FILE.is_file():
        raise FileNotFoundError(f"Customer data file not found: {DATA_FILE}")

    data = pd.read_csv(DATA_FILE)
    data.columns = data.columns.str.strip().str.lower()
    missing_columns = REQUIRED_COLUMNS.difference(data.columns)
    if missing_columns:
        raise ValueError(
            "Customer_Data.csv is missing required columns: "
            + ", ".join(sorted(missing_columns))
        )
    return data


st.set_page_config(page_title="Customer Churn Analysis", page_icon="📊", layout="wide")
st.title("Customer Churn Analysis")
st.caption("Explore customer retention patterns using the included CSV dataset.")

df = load_data()

with st.sidebar:
    st.header("Filters")
    contracts = ["All"] + sorted(df["contract"].dropna().unique().tolist())
    payments = ["All"] + sorted(df["payment_method"].dropna().unique().tolist())
    states = ["All"] + sorted(df["state"].dropna().unique().tolist())
    selected_contract = st.selectbox("Contract", contracts)
    selected_payment = st.selectbox("Payment method", payments)
    selected_state = st.selectbox("State", states)

filtered = df
if selected_contract != "All":
    filtered = filtered[filtered["contract"] == selected_contract]
if selected_payment != "All":
    filtered = filtered[filtered["payment_method"] == selected_payment]
if selected_state != "All":
    filtered = filtered[filtered["state"] == selected_state]

churned = filtered["customer_status"].eq("Churned")
churn_rate = churned.mean() if len(filtered) else 0
retained = filtered["customer_status"].eq("Stayed").sum()
average_monthly_charge = filtered["monthly_charge"].mean()

total_col, churn_col, retained_col, charge_col = st.columns(4)
total_col.metric("Customers", f"{len(filtered):,}")
churn_col.metric("Churn rate", f"{churn_rate:.1%}")
retained_col.metric("Stayed", f"{retained:,}")
charge_col.metric(
    "Average monthly charge",
    f"${average_monthly_charge:,.2f}" if pd.notna(average_monthly_charge) else "N/A",
)

left, right = st.columns(2)
with left:
    st.subheader("Churn rate by contract")
    contract_churn = (
        filtered.assign(is_churned=churned)
        .groupby("contract", dropna=False)["is_churned"]
        .mean()
        .sort_values(ascending=False)
        .mul(100)
        .rename("Churn rate (%)")
    )
    st.bar_chart(contract_churn)

with right:
    st.subheader("Customer status")
    status_counts = filtered["customer_status"].value_counts().rename("Customers")
    st.bar_chart(status_counts)

left, right = st.columns(2)
with left:
    st.subheader("Churn by payment method")
    payment_churn = (
        filtered.assign(is_churned=churned)
        .groupby("payment_method")["is_churned"]
        .mean()
        .sort_values(ascending=False)
        .mul(100)
        .rename("Churn rate (%)")
    )
    st.bar_chart(payment_churn)

with right:
    st.subheader("Top churn reasons")
    reasons = filtered.loc[churned, "churn_reason"].dropna()
    reason_counts = reasons.value_counts().head(10).rename("Customers")
    if reason_counts.empty:
        st.info("No churn reasons for the selected filters.")
    else:
        st.bar_chart(reason_counts)

with st.expander("View filtered customer data"):
    st.dataframe(filtered, use_container_width=True, hide_index=True)
