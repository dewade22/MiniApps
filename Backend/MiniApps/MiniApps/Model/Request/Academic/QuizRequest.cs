#nullable disable
using System.ComponentModel.DataAnnotations;

namespace MiniApps.Model.Request.Academic
{
    public class QuizRequest
    {
        [Required]
        public string Title { get; set; }

        /// <summary>"quiz" | "daily_test" | "semester_test"</summary>
        [Required]
        [RegularExpression("^(quiz|daily_test|semester_test)$",
            ErrorMessage = "AssessmentType must be 'quiz', 'daily_test', or 'semester_test'.")]
        public string AssessmentType { get; set; } = "quiz";

        // ── Filters (quiz / semester_test) ──────────────────────────────────
        /// <summary>Single subject filter — used for quiz and semester_test types.</summary>
        public string SubjectUuid { get; set; }

        /// <summary>Single topic filter — used for quiz and semester_test types.</summary>
        public string TopicUuid { get; set; }

        // ── Multi-topic (daily_test) ─────────────────────────────────────────
        /// <summary>Required for daily_test: one or more topic UUIDs the test covers.</summary>
        public List<string> TopicUuids { get; set; } = new();

        [Required]
        public string GradeUuid { get; set; }

        /// <summary>UUIDs of the questions to include. Must all be eligible for the selected grade.</summary>
        [Required]
        [MinLength(1)]
        public List<string> SelectedQuestionUuids { get; set; }

        /// <summary>Must be >= calculated MinTimeSeconds.</summary>
        [Required]
        [Range(1, int.MaxValue)]
        public int TimeLimitSeconds { get; set; }

        [Required]
        [Range(1, int.MaxValue)]
        public int TimeVeryEasy { get; set; } = 30;

        [Required]
        [Range(1, int.MaxValue)]
        public int TimeEasy { get; set; } = 45;

        [Required]
        [Range(1, int.MaxValue)]
        public int TimeMedium { get; set; } = 60;

        [Required]
        [Range(1, int.MaxValue)]
        public int TimeHard { get; set; } = 90;

        [Required]
        [Range(1, int.MaxValue)]
        public int TimeVeryHard { get; set; } = 120;
    }
}
