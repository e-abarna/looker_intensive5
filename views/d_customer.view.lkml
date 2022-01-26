view: d_customer {
  sql_table_name: "DATA_MART"."D_CUSTOMER"
    ;;

  dimension: c_address {
    type: string
    sql: ${TABLE}."C_ADDRESS" ;;
  }

  dimension: c_custkey {
    type: number
    sql: ${TABLE}."C_CUSTKEY" ;;
  }

  dimension: c_mktsegment {
    type: number
    sql: ${TABLE}."C_MKTSEGMENT" ;;
  }

  dimension: c_name {
    type: string
    sql: ${TABLE}."C_NAME" ;;
  }

  dimension: c_nation {
    type: string
    sql: ${TABLE}."C_NATION" ;;
  }

  dimension: c_phone {
    type: string
    sql: ${TABLE}."C_PHONE" ;;
  }

  dimension: c_region {
    type: string
    sql: ${TABLE}."C_REGION" ;;
  }

  measure: count {
    type: count
    drill_fields: [c_name]
  }
}
