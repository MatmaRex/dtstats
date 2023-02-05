with
change_tag_with_def as (
	select *
	from change_tag
	left join change_tag_def on ct_tag_id=ctd_id
),
ignored_tags(ignored_tag) as (
	-- Ignore this tag because it would be listed in every entry
	select * from (values ('discussiontools-added-comment')) values1
	union all
	-- Ignore other DiscussionTools tags to group everything under 'discussiontools'
	select distinct ctd_name from change_tag_with_def where ctd_name like 'discussiontools-%'
	union all
	-- Ignore redundant tags
	select * from (values ('mobile web edit'), ('advanced mobile edit'), ('mobile app edit')) values2
	union all
  -- Boring
	select * from (values ('visualeditor-switched')) values3
	union all
	-- Ignore some tags based on the content of the edit, rather than the editor software
	select * from (values
		('mw-contentmodelchange'), ('mw-new-redirect'), ('mw-removed-redirect'), ('mw-changed-redirect-target'), ('mw-blank'), ('mw-replace'), ('mw-rollback'), ('mw-undo'), ('mw-manual-revert'), ('mw-reverted'), ('mw-server-side-upload'),
		('mw-add-media'), ('mw-remove-media'), -- Removed from core
    ('disambiguator-link-added')
	) values4
	union all
  -- Ignore abuse filter tags
	select distinct afa_parameters from abuse_filter_action where afa_consequence = 'tag'
	union all
	-- Ignore manually added tags
	select distinct ls_value
	from log_search
	left join logging on log_id=ls_log_id
	where ls_field='Tag'
	and log_type='tag' and log_action='update'
),
change_tag_with_def_interesting as (
	select *
	from change_tag_with_def
	where ctd_name not in (select * from ignored_tags)
),
revision_adding_comments_not_bots as (
	-- Need to query change_tag first for reasonable performance, otherwise it tried to scan all revisions
	select distinct rev_id, rev_timestamp
	from change_tag_with_def
	inner join revision on rev_id=ct_rev_id
	where (ctd_name = 'discussiontools-added-comment' or ctd_name = 'discussiontools')
	-- select *
	-- from revision
	-- where exists(
	-- 	select 1
	-- 	from change_tag_with_def
	-- 	where rev_id=ct_rev_id
	-- 	and (ctd_name = 'discussiontools-added-comment' or ctd_name = 'discussiontools')
	-- )
	and not exists(
		select 1
		from user_groups
		left join actor on ug_user=actor_user
		where ug_group='bot' and actor_id=rev_actor
	)
),
most_used_tags_not_bots as (
	select ctd_name from (
		select ctd_name, count(*) as count
		from revision_adding_comments_not_bots
		inner join change_tag_with_def_interesting on rev_id=ct_rev_id
		-- where rev_timestamp between '202212' and '202301'
		group by ctd_name
		order by count desc
	) x
	order by count desc
	limit 6
),
interesting_revisions_with_interesting_tags as (
	select
		rev_id, rev_timestamp,
		coalesce(group_concat(tags.ctd_name), mobiletags.ctd_name) as ctd_name
	from revision_adding_comments_not_bots
	-- concat all interesting tags except "mobile edit",
	-- then add "mobile edit" back if it was otherwise the only tag
	left outer join change_tag_with_def tags on rev_id=tags.ct_rev_id
		and (tags.ctd_name in (select * from most_used_tags_not_bots)
			or tags.ctd_name is null)
		and tags.ctd_name != 'mobile edit'
	left outer join change_tag_with_def mobiletags on rev_id=mobiletags.ct_rev_id
		and mobiletags.ctd_name = 'mobile edit'
	group by rev_id, rev_timestamp
)
select
	date_format(rev_timestamp, '%Y%m') as month,
	ctd_name,
	count(*)
from interesting_revisions_with_interesting_tags
group by 1, 2
-- Preferred order: 'discussiontools', 'mobile edit', 'wikieditor', NULL, then everything else
order by month, case
	when ctd_name = 'discussiontools' then 1
	when ctd_name = 'mobile edit' then 2
	when ctd_name = 'wikieditor' then 3
	when ctd_name is null then 4
	else 4
end, ctd_name
