view: google_search {
  derived_table: {
    sql:
      SELECT gs.*,
      node_id,
      SPLIT_PART(site, '/',3) as page_urlhost,
      CASE WHEN (SPLIT_PART(page, '?',1) = 'https://www2.gov.bc.ca/gov/search')
            THEN 'Search'
            ELSE SPLIT_PART(cms.dcterms_creator, '|', 2)
            END AS page_owner,
      dd.isweekend::BOOLEAN,
      dd.isholiday::BOOLEAN,
      dd.sbcquarter, dd.lastdayofpsapayperiod::date
      FROM google.googlesearch AS gs
      JOIN servicebc.datedimension AS dd on date::date = dd.datekey::date
      LEFT JOIN cmslite.metadata AS cms ON cms.hr_url = page
      ;;

      sql_trigger_value: SELECT FLOOR((EXTRACT(epoch from GETDATE()) - 60*60*7)/(60*60*24)) ;;
      distribution_style: all

    }

    ###
    filter: yesno_filter {
      type: yesno
    }

    dimension: node_id {
      type: string
      sql:  ${TABLE}.node_id ;;
    }
    dimension: page_owner {
      type: string
      sql:  ${TABLE}.page_owner ;;
    }
    dimension: date {
      type:  date
      sql:  ${TABLE}.date ;;
      group_label: "Date"
    }
    dimension: week {
      type:  date_week_of_year
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
      link: {
        label: "View Search"
        url: "https://google.ca/search?q={{ value }}"
        icon_url: "https://looker.com/favicon.ico"
      }
    }
    dimension: country {
      type: string
      sql: ${TABLE}.country;;
    }
    dimension: device {
      type: string
      sql: ${TABLE}.device;;
    }
    dimension: page {
      type: string
      sql: ${TABLE}.page;;
      drill_fields: [google_search.query]
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
  }
