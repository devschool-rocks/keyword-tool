class CreateSerpsView < ActiveRecord::Migration
  def down
    drop_table :serps_views
    execute %{DROP VIEW serps}
  end

  def up
    create_table :serps_views do |t|
      execute %{
CREATE VIEW serps AS
with days as (
  select day::date
  from generate_series(date '2016-01-01', date '2016-02-01', interval '1' day) day
)
select d.day as created_on, dm.value as domain, k.value as keyword, r.position,
       (select rankings.position from rankings
        left join domains domains on rankings.domain_id = domains.id
        left join keywords keywords on rankings.keyword_id = keywords.id
        where CAST(rankings.created_at as DATE) = day - interval '1' day AND
              domains.value = dm.value AND
              keywords.value = k.value
        LIMIT 1) as yesterday
from days d
  left join rankings r on CAST(r.created_at as DATE) = d.day
  left join domains dm on r.domain_id = dm.id
  left join keywords k on r.keyword_id = k.id
group by d.day, dm.value, k.value, r.position
order by d.day asc
}
    end
  end
end
