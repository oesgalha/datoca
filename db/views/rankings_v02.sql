WITH top_submissions AS (
  SELECT DISTINCT ON (competitor_id, competitor_type, evaluation_score, competition_id) *
  FROM (
    SELECT id as submission_id, competitor_id, competitor_type, evaluation_score, competition_id,
      rank() OVER (
        PARTITION BY competition_id, competitor_id, competitor_type
        ORDER BY evaluation_score
        ASC
      ) AS competitor_rank
    FROM submissions) per_competitor
  WHERE competitor_rank = 1
)
SELECT submission_id, competitor_id, competitor_type, evaluation_score, competition_id,
  rank() OVER (
    PARTITION BY competition_id
    ORDER BY evaluation_score
    ASC
  )
FROM top_submissions;
