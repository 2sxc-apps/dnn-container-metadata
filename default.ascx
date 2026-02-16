<%-- This has all common 2sxc services and GetScopedService(...)  --%>
<%@ Import Namespace="ToSic.Sxc.Services" %>
<%-- This namespace provides ITypedApi --%>
<%@ Import Namespace="ToSic.Sxc.Code" %>
<%-- This namespace provides metadata APIs --%>
<%@ Import Namespace="ToSic.Eav.Metadata" %>
<%-- This namespace provides models APIs --%>
<%@ Import Namespace="ToSic.Eav.Models" %>
<%-- This namespace provides models APIs --%>
<%@ Import Namespace="ToSic.Eav.Data" %>

<script runat="server">

  /// <summary>
  /// Get the Context and API of this module and keep for re-use.
  /// Note that ??= would have been more elegant, but not supported in older C#.
  /// </summary>
  protected ITypedApi SxcSiteApi => _ssa ?? (_ssa = this.GetScopedService<ITypedApiService>().ApiOfModule(ModuleConfiguration.TabID, ModuleConfiguration.ModuleID));
  private ITypedApi _ssa;

  /// <summary>
  /// Get the PageToolbar to show somewhere using <%= ModuleToolbar() %> or <%= ModuleToolbar().AsTag() %>
  /// </summary>
  private ToSic.Sxc.Edit.Toolbar.IToolbarBuilder ModuleToolbar() =>
    SxcSiteApi.Kit.Toolbar
      // Add the default metadata button(s) for this module - ATM just notes, but in future could be more
      .Metadata(SxcSiteApi.MyContext.Module)
      // Add button to edit the custom ModuleMetadata type (define in the Site-App)
      .Metadata(SxcSiteApi.MyContext.Module, contentTypes: "ModuleMetadata");

  /// <summary>
  /// Get the ModuleMetadata for this module, which contains the BackgroundColor property.
  /// Will create an empty ModuleMetadata if not yet created, so that all values always exist
  /// and can be used in the .ascx without null-checks.
  /// </summary>
  private ModuleMetadata Metadata => _metadata
    ?? (_metadata = SxcSiteApi.MyContext.Module.TryGetMetadata<ModuleMetadata>() ?? new ModuleMetadata());
  private ModuleMetadata _metadata;


  class ModuleMetadata: ModelOfEntityClassic
  {
    public string BackgroundColor => GetThis<string>("white");
  }
</script>


<%@ Control language="C#" AutoEventWireup="false" Explicit="True" Inherits="DotNetNuke.UI.Containers.Container" %>
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

<hr>
<hr>

<h5>
  debug
  <%= ModuleToolbar().AsTag() %>
</h5>
<br>
Module: <%= SxcSiteApi.MyContext.Module.Id %>

<hr>
<ol>
  <li>Tab ID: <%= ModuleConfiguration.TabID %></li>
  <li>Module ID: <%= ModuleConfiguration.ModuleID %></li>
  <li>TabModuleId: <%= ModuleConfiguration.TabModuleID %></li>
  <li>
    Note: <%= SxcSiteApi.MyContext.Module.TryGetMetadata<ToSic.Sxc.Cms.Notes.INoteModel>()?.Note %>
  </li>
  <li>
    Background Color: <%= Metadata?.BackgroundColor %>
</ol>