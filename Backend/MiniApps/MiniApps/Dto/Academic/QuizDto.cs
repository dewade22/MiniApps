#nullable disable
using MA.Framework.Dto.Base;

namespace MiniApps.Dto.Academic
{
    public class QuizDto : AuditableDto<string>
    {
        public string Title { get; set; }

        public string SubjectUuid { get; set; }
        public string SubjectName { get; set; }

        public string TopicUuid { get; set; }
        public string TopicName { get; set; }

        public string GradeUuid { get; set; }
        public string GradeName { get; set; }

        public int QuestionCount { get; set; }
        public int TimeLimitSeconds { get; set; }
        public int MinTimeSeconds { get; set; }

        public int TimeVeryEasy { get; set; }
        public int TimeEasy { get; set; }
        public int TimeMedium { get; set; }
        public int TimeHard { get; set; }
        public int TimeVeryHard { get; set; }

        /// <summary>"quiz" | "daily_test" | "semester_test"</summary>
        public string AssessmentType { get; set; } = "quiz";
        public bool ShowScoreImmediately { get; set; } = true;

        /// <summary>Populated for daily_test: topics the quiz covers.</summary>
        public List<QuizTopicDto> Topics { get; set; } = new List<QuizTopicDto>();

        public List<QuizQuestionDto> Questions { get; set; } = new List<QuizQuestionDto>();
    }
}
