### Usage stats for DiscussionTools and other methods of adding talk page comments
### https://dtstats.toolforge.org/

Data includes all edits by users that aren't bots which add a discussion comment.

(It does not include other edits on talk pages, and it includes comments on pages outside of the talk namespaces.)

I arbitrarily picked the wikis from `large` dblist to display.

The edit count for top 6 tags, plus the count for other/untagged edits, is shown for each wiki.

The "mobile edit" tag has special treatment: it is only counted when it is the only interesting tag on an edit – otherwise the edit is counted for whichever other tags are present. For example, mobile DiscussionTools edits are just counted as DiscussionTools.


#### Caveats

Use this data **only for fun**. Do not make decisions based on this data alone. Counting edits with tags is hard, and there may be mistakes in the queries.

Prior to 2021-08, we did not track which edits add a discussion comment, so that data is missing (except for DiscussionTools edits, which are assumed to add comments).

Prior to 2021-12, we did not track which edits were made with WikiEditor (2010 wikitext editor), so that data is missing as well.


#### Fun observations

Wikis are *very* different.

Mobile usage in particular varies a lot.

On some wikis you can clearly see when we switched reply or new topic tool from hidden to beta to opt-out (enwiki), or enabled them on mobile (arwiki).

DiscussionTools, mobile web edits and WikiEditor are in the top 6 on every wiki.

Other top tags often include anti-vandalism tools (Twinkle, RedWarn, SWViewer [OAuth 1805]), Growth team's mentorship features, mobile apps, and sometimes VisualEditor and 2017WTE.

Some wikis have almost zero "other" tool usage (cawiki, srwiki), while on some wikis it's a huge chunk (plwiki, ukwiki). They could be specialized tools (e.g. for deletion discussions), other talk page tools (e.g. ConvenientDiscussions), or unmarked bot edits.

There are some weird seasonal spikes that I did not try to explain (e.g. enwikinews). Some can be explained though (big spike on metawiki looks like the Community Wishlist Survey). On kowiki some terrible calamity has affected mobile editing (did they block it or something?).

DiscussionTools uptake varies a lot, from >50% to ~10% depending on the wiki.

Some "large" wikis have practically no discussion (they just have lots of bot-generated articles).

DiscussionTools usage has grown at the expense of WikiEditor and the default mobile editor (on wikis where it's enabled on mobile), without noticeably affecting usage of other tools.
