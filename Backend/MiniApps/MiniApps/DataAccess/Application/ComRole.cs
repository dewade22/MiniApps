using System;
using System.Collections.Generic;

namespace MiniApps.DataAccess.Application;

public partial class ComRole
{
    public string Uuid { get; set; } = null!;

    public string Rolename { get; set; } = null!;

    public string Createdby { get; set; } = null!;

    public DateTime Createdat { get; set; }

    public string Updatedby { get; set; } = null!;

    public DateTime Updatedat { get; set; }

    public virtual ICollection<ComUserinrole> ComUserinroles { get; set; } = new List<ComUserinrole>();
}
