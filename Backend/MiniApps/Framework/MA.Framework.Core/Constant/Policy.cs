namespace MA.Framework.Core.Constant
{
    public class Policy
    {
        public const string Administrator = "Admin";
        public const string Teacher = "Teacher";
        public const string Student = "Student";
        //public const string AllRoles = Administrator + "," + Guest;
        public const string AllRoles = $"{Administrator},{Teacher},{Student}";
        public const string TeacherStudent = $"{Teacher},{Student}";
    }
}
