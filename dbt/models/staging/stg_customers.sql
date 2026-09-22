with source as (
    select * from {{ source('raw_data', 'raw_customers') }}
),

renamed as (
    select
        customer_key as customer_id,
        trim(prefix) as name_prefix,
        trim(first_name) as first_name,
        trim(last_name) as last_name,
        trim(upper(first_name) || ' ' || upper(last_name)) as full_name,
        try_to_date(birth_date) as birth_date,
        trim(marital_status) as marital_status,
        case
            when trim(marital_status) = 'M' then 'Married'
            when trim(marital_status) = 'S' then 'Single'
            else 'Unknown'
        end as marital_status_desc,
        trim(gender) as gender,
        case
            when trim(gender) = 'M' then 'Male'
            when trim(gender) = 'F' then 'Female'
            else 'Unknown'
        end as gender_desc,
        trim(lower(email_address)) as email_address,
        try_to_number(regexp_replace(annual_income, '[^0-9.]', '')) as annual_income,
        coalesce(total_children, 0) as total_children,
        trim(education_level) as education_level,
        trim(occupation) as occupation,
        trim(home_owner) as home_owner_flag,
        case
            when trim(home_owner) = 'Y' then true
            when trim(home_owner) = 'N' then false
            else null
        end as is_home_owner,
        current_timestamp() as _loaded_at
    from source
    where customer_key is not null
)

select * from renamed
