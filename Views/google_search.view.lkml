include: "/Includes/date_comparisons_common.view"

view: google_search {
  sql_table_name: cmslite.google_pdt ;;


  extends: [date_comparisons_common]

  dimension_group: filter_start {
    sql: ${TABLE}.date ;;
  }


    ###
    filter: yesno_filter {
      type: yesno
    }

    dimension: node_id {
      type: string
      sql:  ${TABLE}.node_id ;;
    }
    dimension: date {
      type:  date
      drill_fields: [query,page]
      sql:  ${TABLE}.date ;;
      group_label: "Date"
    }
    dimension: week {
      type:  date_week
      sql:  ${TABLE}.date ;;
      group_label: "Date"
    }
    dimension: month {
      type:  date_month_name
      sql:  ${TABLE}.date ;;
      group_label: "Date"
    }
    dimension: year {
      type:  date_year
      sql:  ${TABLE}.date ;;
      group_label: "Date"
    }

    dimension: day_of_month {
      type:  date_day_of_month
      sql:  ${TABLE}.date ;;
      group_label: "Date"
    }
    dimension: day_of_week {
      type:  date_day_of_week
      sql:  ${TABLE}.date ;;
      group_label: "Date"
    }
    dimension: day_of_week_number {
      type:  date_day_of_week_index
      sql:  ${TABLE}.date + interval '1 day' ;;
      group_label: "Date"
    }


    dimension: is_weekend {
      type:  yesno
      sql:  ${TABLE}.isweekend ;;
      group_label:  "Date"
    }
    dimension: is_holiday {
      type:  yesno
      sql:  ${TABLE}.isholiday ;;
      group_label:  "Date"
    }
    dimension: fiscal_year {
      type:  date_fiscal_year
      sql:  ${TABLE}.date ;;
      group_label:  "Date"
    }
    dimension: fiscal_month {
      type:  date_fiscal_month_num
      sql:  ${TABLE}.date ;;
      group_label:  "Date"
    }
    dimension: fiscal_quarter {
      type:  date_fiscal_quarter
      sql:  ${TABLE}.date ;;
      group_label:  "Date"
    }
    dimension: fiscal_quarter_of_year {
      type:  date_fiscal_quarter_of_year
      sql:  ${TABLE}.date ;;
      group_label:  "Date"
    }
    dimension: sbc_quarter {
      type:  string
      sql:  ${TABLE}.sbcquarter ;;
      group_label:  "Date"
    }
    dimension: last_day_of_pay_period {
      type: date
      sql:  ${TABLE}.lastdayofpsapayperiod ;;
      group_label: "Date"
    }

    dimension: query {
      type: string
      sql: ${TABLE}.query;;
      drill_fields: [page,country]
      link: {
        label: "View Search"
        url: "https://google.ca/search?q={{ value }}"
        icon_url: "https://looker.com/favicon.ico"
      }
    }

    dimension: splitquery {
      type: string
      sql: CASE WHEN ${TABLE}.query LIKE '%child care%' THEN 'child care'
            WHEN ${TABLE}.query LIKE '%childcare%' THEN 'childcare'
            WHEN ${TABLE}.query LIKE '%day care%' THEN 'day care'
            WHEN ${TABLE}.query LIKE '%daycare%' THEN 'daycare'
          ELSE NULL END
      ;;
    }

    dimension: country {
      type: string
      drill_fields: [page,query]
      sql: ${TABLE}.country;;
    }
    dimension: device {
      type: string
      sql: ${TABLE}.device;;
    }

    dimension: is_mobile {
      type: yesno
      description: "True if the viewing device is mobile; False otherwise."
      sql: ${device} = "MOBILE" ;;
    }

    dimension: page {
      type: string
      sql: ${TABLE}.page;;
      drill_fields: [query,country]
      link: {
        label: "Visit Page"
        url: "{{ value }}"
        icon_url: "https://looker.com/favicon.ico"
      }
    }

    dimension: page_urlhost {
      type: string
      sql: ${TABLE}.page_urlhost ;;
    }

    dimension: site {
      type: string
      sql:  ${TABLE}.site ;;
    }
    dimension: position {
      type: number
      sql: ${TABLE}.position;;
      group_label: "Counts"
    }
    dimension: clicks {
      type: number
      sql: ${TABLE}.clicks;;
      group_label: "Counts"
    }
    dimension: ctr {
      type: number
      sql: ${TABLE}.ctr;;
      group_label: "Counts"
    }
    dimension: impressions {
      type: number
      sql: ${TABLE}.impressions;;
      group_label: "Counts"
    }


    measure: total_clicks {
      type: sum
      sql: ${TABLE}.clicks;;
      group_label: "Counts"
    }
    measure: total_impressions {
      type: sum
      sql: ${TABLE}.impressions;;
      group_label: "Counts"
    }

  measure: total_click_through_rate {
    type: number
    value_format_name: "percent_2"
    sql: ${total_clicks}/${total_impressions};;
    group_label: "Counts"
  }

    measure: average_position {
      type: average
      sql: ${TABLE}.position;;
      group_label: "Averages"
    }
    measure: average_clicks {
      type: average
      sql: ${TABLE}.clicks;;
      group_label: "Averages"
    }
    measure: average_ctr {
      type: average
      sql: ${TABLE}.ctr;;
      group_label: "Averages"
    }
    measure: average_impressions {
      type: average
      sql: ${TABLE}.impressions;;
      group_label: "Averages"
    }

  # node_id
  # the CMSL node ID

  # theme
  # the CMSL theme
  dimension: theme {
    description: "The CMS Lite theme."
    type: string
    drill_fields: [subtheme, topic, google_search.query]
    sql: COALESCE(${TABLE}.theme, '(no theme)') ;;
    suggest_explore: theme_cache
    suggest_dimension: theme_cache.theme
  }

  # node_id
  # the CMSL theme ID
  #
  # the COALESCSE expression ensures that a blank value is returned in the
  # case where the ${TABLE}.theme_id value is missing or null; ensurinig that
  # user attribute filters will continue to work.
  #
  # reference - https://docs.aws.amazon.com/redshift/latest/dg/r_NVL_function.html
  dimension: theme_id {
    description: "The alphanumeric CMS Lite theme identifer."
    type: string
    sql: COALESCE(${TABLE}.theme_id,'') ;;
  }

  # subtheme
  # the CMSL subtheme
  dimension: subtheme {
    description: "The CMS Lite subtheme."
    type: string
    drill_fields: [topic, google_search.query]
    sql: COALESCE(${TABLE}.subtheme, '(no subtheme)') ;;
    suggest_explore: theme_cache
    suggest_dimension: theme_cache.subtheme
  }

  # subtheme ID
  # the CMSL subtheme ID
  dimension: subtheme_id {
    description: "The alphanumeric CMS Lite subtheme identifier."
    type: string
    sql: COALESCE(${TABLE}.subtheme_id,'');;
  }

  # topic
  # the CMSL topic
  dimension: topic {
    description: "The CMS Lite topic."
    type: string
    sql: COALESCE(${TABLE}.topic, '(no topic)') ;;
    drill_fields: [google_search.query]
    suggest_explore: theme_cache
    suggest_dimension: theme_cache.topic
  }

  # topic ID
  # the CMSL topic ID
  dimension: topic_id {
    description: "The alphanumeric CMS Lite topic identifier."
    type: string
    sql: COALESCE(${TABLE}.topic_id,'') ;;
  }

  dimension: title {
    sql: COALESCE(${TABLE}.title, ${TABLE}.page) ;;
    link: {
      label: "Visit {{ google_search.page._value }}"
      url: "{{ google_search.page._value }}"
      icon_url: "https://looker.com/favicon.ico"
    }
  }
  }
