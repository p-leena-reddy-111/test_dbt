{{config(
    severity='warn'
)}}

WITH bronze AS (

SELECT COUNT(*) as bronze_count

FROM {{ source('raw','raw_customers') }}

),

silver AS (

SELECT COUNT(*) as silver_count
FROM {{ ref('stg_customers') }}

)

SELECT
	bronze.bronze_count,
	silver.silver_count,
	bronze.bronze_count - silver.silver_count as count_difference

FROM bronze
CROSS JOIN silver

WHERE bronze.bronze_count <> silver.silver_count