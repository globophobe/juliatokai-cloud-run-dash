module InputValidation

using Dates

export parse_dates, valid_dates


function valid_dates(start_date, end_date; max_days = 7)
    start_d, end_d = parse_dates(start_date, end_date)

    if !isnothing(start_d) && !isnothing(end_d)
        days = end_d - start_d 
        if Dates.value(days) <= max_days
            return true 
        end
    end

    return false
end

function parse_dates(start_date, end_date)
    start_d = start_date isa String ? Dates.Date(start_date) : nothing
    end_d = end_date isa String ? Dates.Date(end_date) : nothing
    start_d, end_d
end

end
