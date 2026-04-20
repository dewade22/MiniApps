namespace MiniApps.Model.Response.Academic
{
    public class QuizPreviewResponse
    {
        public int AvailableQuestions { get; set; }
        public int SelectableCount { get; set; }
        public int MinTimeSeconds { get; set; }
        public Dictionary<string, int> DifficultyBreakdown { get; set; } = new();
    }
}
