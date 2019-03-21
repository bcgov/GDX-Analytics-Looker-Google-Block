connection: "redshift_pacific_time"
# Set the week start day to Sunday. Default is Monday
week_start_day: sunday
# Set fiscal year to begin April 1st -- https://docs.looker.com/reference/model-params/fiscal_month_offset
fiscal_month_offset: 3

# include all views in this project
include: "*.view"

# For now, don't include the dashboard we built. There is an editable version in the Shared -> Service BC Folder
# include: "*.dashboard"


explore: google_search {
  join: cmslite_themes {
    type: left_outer
    sql_on: ${google_search.node_id} = ${cmslite_themes.node_id} ;;
    relationship: one_to_one
  }

  access_filter: {
    field: node_id
    user_attribute: node_id
  }

  access_filter: {
    field: page_urlhost
    user_attribute: urlhost
  }
  access_filter: {
    field: cmslite_themes.theme_id
    user_attribute: theme
  }
}
