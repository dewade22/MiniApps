using System;
using System.Collections.Generic;

namespace MiniApps.DataAccess.Application;

public partial class ComUseraccount
{
    public string Uuid { get; set; } = null!;

    public string Emailaddress { get; set; } = null!;

    public string Firstname { get; set; } = null!;

    public string Lastname { get; set; } = null!;

    public string Timezoneid { get; set; } = null!;

    public bool Isarchived { get; set; }

    public string Createdby { get; set; } = null!;

    public DateTime Createdat { get; set; }

    public string Updatedby { get; set; } = null!;

    public DateTime Updatedat { get; set; }

    public virtual ICollection<ComUserinrole> ComUserinroles { get; set; } = new List<ComUserinrole>();

    public virtual ICollection<ComUsermembership> ComUsermemberships { get; set; } = new List<ComUsermembership>();

    public virtual ICollection<ComUserrefreshtoken> ComUserrefreshtokens { get; set; } = new List<ComUserrefreshtoken>();
}
