connection: "tpchlooker"

# include all the views
include: "/views/**/*.view"

datagroup: looker_test_project_22_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: looker_test_project_22_default_datagroup

explore: d_customer {}

explore: d_dates {}

explore: d_part {}

explore: d_supplier {}

explore: f_lineitems {}
