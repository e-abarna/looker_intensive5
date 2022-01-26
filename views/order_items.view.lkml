view: order_items {
  sql_table_name: "PUBLIC"."ORDER_ITEMS"
    ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."ID" ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."CREATED_AT" ;;
  }

  dimension_group: delivered {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."DELIVERED_AT" ;;
  }

  dimension: shipping_days {
    type: number
    sql: DATEDIFF(days, ${shipped_date},${delivered_date}) ;;
  }

  dimension: inventory_item_id {
    type: number
    # hidden: yes
    sql: ${TABLE}."INVENTORY_ITEM_ID" ;;
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}."ORDER_ID" ;;
  }

  dimension_group: returned {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."RETURNED_AT" ;;
  }

  dimension: is_returned {
    type: yesno
    description: "Is the order returned?"
    sql: not ${returned_date} is null  ;;
  }

  dimension: sale_price {
    type: number
    sql: ${TABLE}."SALE_PRICE" ;;
  }

  dimension_group: shipped {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."SHIPPED_AT" ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}."STATUS" ;;
  }

  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}."USER_ID" ;;
  }

  dimension: is_completed {
    description: "Is order complete?"
    type: yesno
    sql: UPPER(${status}) NOT IN ('CANCELLED', 'RETURNED') ;;
  }

  # dimension: is_returned {
  #   description: "Is order returned?"
  #   type: yesno
  #   sql: upper(${status}) IN ('RETURNED') ;;
  # }

  measure: count {
    type: count
    drill_fields: [detail_for_customer_explore*]
  }

  measure: total_sale_price {
    description: "Total sales from items sold"
    type: sum
    value_format: "$#.00;($#.00)"
    sql: ${sale_price} ;;
  }

  measure: average_sale_price {
    description: "Average sale price of items sold"
    type: average
    value_format: "$#.00;($#.00)"
    sql: ${sale_price} ;;
  }

  measure: cumulative_total_sales {
    description: "Cumulative total sales from items sold(also known as running total)"
    type: running_total
    value_format: "$#.00;($#.00)"
    sql: ${total_sale_price} ;;
  }

  measure: total_gross_revenue {
    description: "Total revenue from completed sales (cancelled and returned orders excluded)"
    type: sum
    value_format_name: usd
    filters: [is_completed: "Yes"]
    sql: ${sale_price} ;;
  }

  measure: total_gross_margin_amount {
    description: "Total difference between the total revenue from completed sales and the cost of the goods that were sold"
    type: sum
    value_format_name: usd
    filters: [is_completed:"Yes"]
    sql: ${sale_price}-${inventory_items.cost} ;;
  }

  measure: gross_margin_percentage {
    description: "Total Gross Margin Amount / Total Gross Revenue"
    label: "Gross Margin %"
    type: number
    value_format_name:  percent_2
    sql: ${total_gross_margin_amount}/nullif(${total_gross_revenue},0) ;;
  }

  measure: count_returned {
    description: "Number of items that were returned by dissatisfied customers"
    label: "Number of Items Returned"
    type: count
    filters: [is_returned: "Yes"]
  }

  measure: item_return_rate {
    description: "Number of users who have returned an item at some point"
    type: number
    value_format_name: percent_2
    sql: ${count_returned}/nullif(${count},0) ;;
  }

  measure: customers_with_returned_items{
    description: "Number of users who have returned an item at some point"
    type: count_distinct
    filters: [is_returned: "Yes"]
    sql: ${user_id} ;;
  }

  # measure:  customer_count{
  #   description: "Total number of customers"
  #   label: "Total Number of Customers"
  #   type: count_distinct
  #   sql: ${user_id} ;;
  # }

  measure: customers_with_returns_rate {
    description: "Number of Customer Returning Items / total number of customers"
    label: "% of Users with Returns"
    type: number
    sql: ${customers_with_returned_items}/nullif(${users.customer_count},0) ;;
  }

  measure: average_spend_pr_customer {
    description: "Total Sale Price / total number of customers"
    label: "Average Spend per Customer"
    type: number
    value_format_name: usd
    sql: ${total_sale_price}/nullif(${users.customer_count},0) ;;
  }

  # ----- Sets of fields for drilling ------
  set: detail_for_customer_explore {
      fields: [
        id,
        inventory_item_id,
        order_id,
        sale_price,
        status,
        user_id,
        is_returned,
        is_completed,
        total_sale_price,
        average_sale_price,
        cumulative_total_sales,
        count_returned,
        item_return_rate,
        customers_with_returned_items,
        customers_with_returns_rate,
        average_spend_pr_customer
      ]
  }
}
