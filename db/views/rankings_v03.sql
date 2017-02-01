WITH top_submissions AS (
  SELECT DISTINCT ON (competitor_id, competitor_type, evaluation_score, competition_id) *
  FROM (
    SELECT submissions.id as submission_id, competitor_id, competitor_type, evaluation_score, competition_id, competitions.metric_sort as metric_sort,
      rank() OVER (
        PARTITION BY competition_id, competitor_id, competitor_type
        ORDER BY
        CASE WHEN metric_sort = 'asc' THEN evaluation_score END ASC,
        CASE WHEN metric_sort = 'desc' THEN evaluation_score END DESC
      ) AS competitor_rank
    FROM submissions INNER JOIN competitions ON competitions.id = submissions.competition_id) per_competitor
  WHERE competitor_rank = 1
)
SELECT submission_id, competitor_id, competitor_type, evaluation_score, competition_id,
  rank() OVER (
    PARTITION BY competition_id
    ORDER BY
    CASE WHEN metric_sort = 'asc' THEN evaluation_score END ASC,
    CASE WHEN metric_sort = 'desc' THEN evaluation_score END DESC
  )
FROM top_submissions;
