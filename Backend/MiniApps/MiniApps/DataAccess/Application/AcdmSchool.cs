using System;
using System.Collections.Generic;

namespace MiniApps.DataAccess.Application;

public partial class AcdmSchool
{
    public string Uuid { get; set; } = null!;
    public string Name { get; set; } = null!;
    public string Code { get; set; } = null!;
    public string Address { get; set; } = null!;
    public string City { get; set; } = null!;
    public string Province { get; set; } = null!;
    public string PostalCode { get; set; } = null!;
    public string Phone { get; set; } = null!;
    public string Email { get; set; } = null!;
    public string? Website { get; set; }
    public string PrincipalName { get; set; } = null!;

    /// <summary>"A" | "B" | "C" | "Not Yet"</summary>
    public string Accreditation { get; set; } = "Not Yet";

    /// <summary>"Public" | "Private"</summary>
    public string SchoolType { get; set; } = "Public";

    /// <summary>"SD" | "SMP" | "SMA" | "SMK"</summary>
    public string EducationLevel { get; set; } = null!;

    public bool IsActive { get; set; } = true;

    public string Createdby { get; set; } = null!;
    public DateTime Createdat { get; set; }
    public string Updatedby { get; set; } = null!;
    public DateTime Updatedat { get; set; }

    public virtual ICollection<AcdmQuiz> AcdmQuizzes { get; set; } = new List<AcdmQuiz>();
}
