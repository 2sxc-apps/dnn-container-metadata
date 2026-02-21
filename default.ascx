<%@ Control language="C#" AutoEventWireup="false" Explicit="True" Inherits="DotNetNuke.UI.Containers.Container" %>

<%@ Import Namespace="ToSic.Sxc.Services" %>  <%-- This has all common 2sxc services and GetScopedService(...)  --%>
<%@ Import Namespace="ToSic.Sxc.Code" %>      <%-- This namespace provides ITypedApi --%>
<%@ Import Namespace="ToSic.Eav.Models" %>    <%-- This namespace provides models APIs like GetMetadataModel<T>() --%>

<script runat="server">

  // Debug to show details below in case of trouble
  private bool debug = false;

  /// <summary>
  /// Get the Context and API of this module and keep for re-use.
  /// Note that ??= would have been more elegant, but not supported in older C#.
  /// </summary>
  private ITypedApi SxcSiteApi => _ssa ?? (_ssa = this.GetScopedService<ITypedApiService>()
    .ApiOfSite(PortalSettings.PortalId, ModuleConfiguration.TabID, ModuleConfiguration.ModuleID)
  );
  private ITypedApi _ssa;

  /// <summary>
  /// Shorthand to quickly access the module later in code
  /// </summary>
  private ToSic.Sxc.Context.ICmsModule MyModule => SxcSiteApi.MyContext.Module;

  /// <summary>
  /// Get the PageToolbar to show somewhere using <%= ModuleToolbar() %> or <%= ModuleToolbar().AsTag() %>
  /// </summary>
  private ToSic.Sxc.Edit.Toolbar.IToolbarBuilder ModuleToolbar() =>
    SxcSiteApi.Kit.Toolbar.Empty()
      // Add the default metadata button(s) for this module - ATM just notes, but in future could be more
      .Metadata(MyModule)
      // Add button to edit the custom ModuleMetadata type (define in the Site-App)
      .Metadata(MyModule, contentTypes: "ModuleMetadata");

  /// <summary>
  /// Get the ModuleMetadata for this module, which contains the BackgroundColor property.
  /// This example assumes that the content-type name is also "ModuleMetadata", as the class name is used to lookup the metadata.
  /// Will create an empty ModuleMetadata if not yet created, so that all values always exist
  /// and can be used in the .ascx without null-checks.
  /// </summary>
  private ModuleMetadata Metadata => _metadata
    ?? (_metadata = MyModule.GetMetadataModel<ModuleMetadata>() ?? new ModuleMetadata());
  private ModuleMetadata _metadata;


  /// <summary>
  /// This is the custom ModuleMetadata class, which is used to store the background color for this module.
  /// </summary>
  /// <remarks>
  /// * It inherits from ModelFromEntityClassic, which means it can be used in Model-APIs such as GetMetadata<T>()
  /// * The BackgroundColor property uses GetThis() to read the value from the metadata, and provides a fallback of "white" if not set.
  /// * You can add more properties here to store more metadata values for this module, and they will automatically be saved to the module's metadata when edited via the toolbar.
  /// * Note that this class is defined in the .ascx file, but it could also be in code-behind or in a DLL
  /// </remarks>
  class ModuleMetadata: ModelFromEntityClassic
  {
    public string BackgroundColor => GetThis(fallback: "white");
  }
</script>


<%-- The main wrapper with a few specials
  1. The ID contains the module-id, which lets content inside add CSS affecting this
  2. The background color is set from the module metadata, which can be edited via the toolbar button
  3. The ModuleToolbar() is a hover-toolbar on the main div
--%>
<div id="module-<%= ModuleConfiguration.ModuleID %>"
  class="to-shine-background-container py-4 py-lg-5"
  style="background-color: <%= Metadata?.BackgroundColor %>"
  <%= ModuleToolbar() %>
>
  <div id="ContentPane" class="container" runat="server"></div>
</div>

<% if (debug) { %>
  <hr>
  <hr>

  <h5>
    debug
    <%= ModuleToolbar().AsTag() %>
  </h5>
  <br>
  Module: <%= MyModule.Id %>

  <hr>
  <ol>
    <li>Site Id: <%= PortalSettings.PortalId %></li>
    <li>Tab ID: <%= ModuleConfiguration.TabID %></li>
    <li>Module ID: <%= ModuleConfiguration.ModuleID %></li>
    <li>TabModuleId: <%= ModuleConfiguration.TabModuleID %></li>
    <li>
      Note: <%= MyModule.GetMetadataModel<ToSic.Sxc.Cms.Notes.INoteModel>()?.Note %>
    </li>
    <li>
      Background Color: <%= Metadata?.BackgroundColor %>
    </li>
    <li>
      Container Class: <%= this.GetType().BaseType.FullName %>
    </li>
  </ol>
<% } %>