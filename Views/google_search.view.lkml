# Version: 1.1.0
include: "//snowplow_web_block/Includes/date_comparisons_common.view"

view: google_search {
  sql_table_name: cmslite.google_dt ;;


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

  dimension_group: google_search {
    type: time
    timeframes: [raw, time, minute, minute10, time_of_day, hour_of_day, hour, date, day_of_month, day_of_week, week, month, quarter, year]
    sql: ${TABLE}.date ;;

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
    description: "Total Clicks / Total Impressions"
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
    drill_fields: [subtheme, topic, subtopic, subsubtopic, google_search.query]
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
    drill_fields: [topic, subtopic, subsubtopic, google_search.query]
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
    drill_fields: [subtopic, subsubtopic, google_search.query]
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

  # subtopic
  # the CMSL subtopic
  dimension: subtopic {
    description: "The CMS Lite subtopic."
    type: string
    sql: COALESCE(${TABLE}.subtopic, '(no subtopic)') ;;
    drill_fields: [subsubtopic, google_search.query]
    suggest_explore: theme_cache
    suggest_dimension: theme_cache.subtopic
  }

  #subtopic ID
  # the CMSL subtopic ID
  dimension: subtopic_id {
    description: "The alphanumeric CMS Lite subtopic identifier."
    type: string
    sql: COALESCE(${TABLE}.subtopic_id,'') ;;
  }

  # subsubtopic
  # the CMSL subsubtopic
  dimension: subsubtopic {
    description: "The CMS Lite subsubtopic."
    type: string
    sql: COALESCE(${TABLE}.subsubtopic, '(no subsubtopic)') ;;
    drill_fields: [google_search.query]
    suggest_explore: theme_cache
    suggest_dimension: theme_cache.subsubtopic
  }

  #subsubtopic ID
  # the CMSL subsubtopic ID
  dimension: subsubtopic_id {
    description: "The alphanumeric CMS Lite subsubtopic identifier."
    type: string
    sql: COALESCE(${TABLE}.subsubtopic_id,'') ;;
  }

  dimension: title {
    sql: COALESCE(${TABLE}.title, ${TABLE}.page) ;;
    link: {
      label: "Visit {{ google_search.page._value }}"
      url: "{{ google_search.page._value }}"
      icon_url: "https://looker.com/favicon.ico"
    }
  }

  # Custom Dimensions for Welcome BC
  dimension: welcomebc_page_section {
    label: "WelcomeBC Page Section"
    type: string
    sql: CASE
          WHEN lower(SPLIT_PART(SPLIT_PART(SPLIT_PART(${TABLE}.page, '//', 2), '/',2),'.aspx',1)) = 'choose-b-c' THEN 'Choose B.C.'
          WHEN lower(SPLIT_PART(SPLIT_PART(SPLIT_PART(${TABLE}.page, '//', 2), '/',2),'.aspx',1)) = 'immigrate-to-b-c' THEN 'Immigrate to B.C.'
          WHEN lower(SPLIT_PART(SPLIT_PART(SPLIT_PART(${TABLE}.page, '//', 2), '/',2),'.aspx',1)) = 'start-your-life-in-b-c' THEN 'Start Your Life in B.C.'
          WHEN lower(SPLIT_PART(SPLIT_PART(SPLIT_PART(${TABLE}.page, '//', 2), '/',2),'.aspx',1)) = 'work-or-study-in-b-c' THEN 'Work or Study in B.C.'
          WHEN lower(SPLIT_PART(SPLIT_PART(SPLIT_PART(${TABLE}.page, '//', 2), '/',2),'.aspx',1)) = 'employer-resources' THEN 'Employer Resources'
          WHEN lower(SPLIT_PART(SPLIT_PART(SPLIT_PART(${TABLE}.page, '//', 2), '/',2),'.aspx',1)) = 'resources-for' THEN 'Resources For'
          ELSE NULL
        END;;
    drill_fields: [google_search.page, google_search.query]
    group_label: "WelcomeBC Dimensions"
  }

  dimension: welcomebc_page_topic {
    label: "WelcomeBC Page Topic"
    sql: CASE
          WHEN SPLIT_PART(SPLIT_PART(lower(${TABLE}.page), '//', 2), '.aspx', 1) in
           ('www.welcomebc.ca/employer-resources',
            'www.welcomebc.ca/employer-resources/b-c-provincial-nominee-program-(pnp)-for-employer',
            'www.welcomebc.ca/employer-resources/b-c-provincial-nominee-program-for-employer/b-c-provincial-nominee-program-for-employers',
            'www.welcomebc.ca/employer-resources/immigration-supports-in-b-c-global-skills-strategy',
            'www.welcomebc.ca/employer-resources/immigration-supports-in-b-c-global-skills-strategy/immigration-supports-in-b-c-global-skills-strategy',
            'www.welcomebc.ca/employer-resources/federal-immigration-programs',
            'www.welcomebc.ca/employer-resources/federal-immigration-programs/about-federal-immigration-programs',
            'www.welcomebc.ca/employer-resources/hire-internationally-trained-workers',
            'www.welcomebc.ca/employer-resources/hire-internationally-trained-workers/why-hire-internationally-trained-workers',
            'www.welcomebc.ca/employer-resources/hire-internationally-trained-workers/recruit-internationally-trained-workers',
            'www.welcomebc.ca/employer-resources/hire-internationally-trained-workers/retain-your-workers',
            'www.welcomebc.ca/employer-resources/hire-temporary-foreign-workers',
            'www.welcomebc.ca/employer-resources/hire-temporary-foreign-workers/temporary-foreign-worker-program ',
            'www.welcomebc.ca/employer-resources/hire-temporary-foreign-workers/international-mobility-program ',
            'www.welcomebc.ca/immigrate-to-b-c/b-c-provincial-nominee-program/bc-pnp-tech-pilot',
            'www.welcomebc.ca/immigrate-to-b-c/b-c-provincial-nominee-program/employer-requirements') THEN 'Employer Related'
          WHEN SPLIT_PART(SPLIT_PART(lower(${TABLE}.page), '//', 2), '.aspx', 1)  in
           ('www.welcomebc.ca/immigrate-to-b-c/bc-pnp-skills-immigration/international-graduate',
            'www.welcomebc.ca/immigrate-to-b-c/bc-pnp-skills-immigration/international-post-graduate',
            'www.welcomebc.ca/immigrate-to-b-c/bc-pnp-express-entry-b-c/eebc-international-graduate',
            'www.welcomebc.ca/immigrate-to-b-c/bc-pnp-express-entry-b-c/eebc-international-post-graduate',
            'www.welcomebc.ca/start-your-life-in-b-c/daily-life/education-in-british-columbia',
            'www.welcomebc.ca/work-or-study-in-b-c/study-in-b-c',
            'www.welcomebc.ca/work-or-study-in-b-c/study-in-b-c/international-students',
            'www.welcomebc.ca/work-or-study-in-b-c/study-in-b-c/training-and-education',
            'www.welcomebc.ca/work-or-study-in-b-c/extend-your-stay-in-b-c/extend-your-study-permit',
            'www.welcomebc.ca/resources-for/international-students',
            'www.welcomebc.ca/resources-for/international-students/come-to-b-c-to-study') THEN 'Student Related'
          WHEN SPLIT_PART(SPLIT_PART(lower(${TABLE}.page), '//', 2), '.aspx', 1)  in
           ('www.welcomebc.ca/immigrate-to-b-c/b-c-provincial-nominee-program/invitations-to-apply',
            'www.welcomebc.ca/immigrate-to-b-c/b-c-provincial-nominee-program/documents',
            'www.welcomebc.ca/immigrate-to-b-c/bc-pnp-skills-immigration/skilled-worker',
            'www.welcomebc.ca/immigrate-to-b-c/bc-pnp-skills-immigration/health-care-professional',
            'www.welcomebc.ca/immigrate-to-b-c/bc-pnp-skills-immigration/entre-level-and-semi-skilled',
            'www.welcomebc.ca/immigrate-to-b-c/bc-pnp-express-entry-b-c/eebc-skilled-worker',
            'www.welcomebc.ca/immigrate-to-b-c/bc-pnp-express-entry-b-c/express-entry-health-care-professional',
            'www.welcomebc.ca/start-your-life-in-b-c/services-and-support/for-temporary-residents',
            'www.welcomebc.ca/work-or-study-in-b-c/work-in-b-c',
            'www.welcomebc.ca/work-or-study-in-b-c/work-in-b-c/find-a-job-in-b-c',
            'www.welcomebc.ca/work-or-study-in-b-c/work-in-b-c/foreign-qualifications-recognition-(fqr)',
            'www.welcomebc.ca/work-or-study-in-b-c/work-in-b-c/temporary-foreign-workers',
            'www.welcomebc.ca/work-or-study-in-b-c/work-in-b-c/know-your-rights-as-a-temporary-foreign-worker',
            'www.welcomebc.ca/work-or-study-in-b-c/work-in-b-c/workplace-information',
            'www.welcomebc.ca/work-or-study-in-b-c/work-in-b-c/employment-language-programs',
            'www.welcomebc.ca/work-or-study-in-b-c/your-career-in-b-c',
            'www.welcomebc.ca/work-or-study-in-b-c/extend-your-stay-in-b-c',
            'www.welcomebc.ca/work-or-study-in-b-c/extend-your-stay-in-b-c/extend-your-stay-in-b-c',
            'www.welcomebc.ca/work-or-study-in-b-c/extend-your-stay-in-b-c/transition-to-permanent-residence',
            'www.welcomebc.ca/work-or-study-in-b-c/extend-your-stay-in-b-c/support-for-temporary-foreign-residents',
            'www.welcomebc.ca/resources-for/temporary-foreign-workers-(tfws)',
            'www.welcomebc.ca/resources-for/temporary-foreign-workers-(tfws)/find-out-about-working-temporarily-in-b-c') THEN 'Worker Related'
          WHEN SPLIT_PART(SPLIT_PART(lower(${TABLE}.page), '//', 2), '.aspx', 1)  in
           ('www.welcomebc.ca/immigrate-to-b-c/b-c-provincial-nominee-program',
            'www.welcomebc.ca/immigrate-to-b-c/bc-pnp-skills-immigration',
            'www.welcomebc.ca/immigrate-to-b-c/bc-pnp-express-entry-b-c',
            'www.welcomebc.ca/immigrate-to-b-c/bc-pnp-entrepreneur-immigration',
            'www.welcomebc.ca/immigrate-to-b-c/other-immigration-options-and-information') THEN 'BC PNP 3rd-Level Pages'
          ELSE NULL
        END;;
    group_label: "WelcomeBC Dimensions"
    drill_fields: [google_search.page, google_search.query]
  }


  }
