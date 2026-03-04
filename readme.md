# DNN Container with Metadata

This is a simple container for DNN, which has the following features:

1. Each container can have configurable metadata
2. ...

Note: It was initially created as a clone of the 2shine DNN Container
and uses Bootstrap 5, but the concept can be applied to any container,
so you can also use it as a template for your own containers.

## Put it into Portals/\_default/Containers/[your-container] or /Portals/[your-portal]-System/Containers/[your-container]

We recommend that you place this in your `/Portals/_default/Containers` area, but you can also put it into your specific portal, like `/Portals/Subsite-System/Containers`.
The following 2 examples assume you want to put it into `_default`.

## Instructions for using Module Level Metadata

### Setup Metadata

The first step is to define what metadata you want to use.

> TIP
> Make sure you are doing this in the SITE scope, not on a specific App, as the data we want to store should be available in the entire site and not in a specific App.

1. Go to the **Primary / Site** App
1. Create a new content-type, for example `ModuleMetadata`
1. Specify one or more fields, for example `BackgroundColor` and `TextColor`

Note that you can always modify this later on.

### Edit Metadata in Container

1. Apply this container to the page/site you want.
2. Adjust the name of the content-type in the container settings to match the one you created, for example `ModuleMetadata`. The name is important, as it's used to retrieve the data.

You should now be able to edit metadata for a specific module.

### Use Metadata in Container

In the container code, you can retrieve the metadata for the current module and use it to adjust the appearance or behavior of the container.

1. Adjust the property names and types in the class `ModuleMetadata` in the container code to match the field names you created, for example `BackgroundColor` and `TextColor`.
1. Put them in the output

### Improve the Button with Custom Color and Icon

To make the button more user-friendly, you can adjust the button for this specific content-type.
It's a bit hidden, but these are the steps:

1. Go to the content-type (in the **Primary / Site** App)
1. To the right of the content type, click on the metadata icon 🏷️
1. In the popup, select add (+)
1. Choose `Toolbar Button Configuration`
1. Set the command to `metadata`
1. Specify the color
1. Optionally add an SVG of an icon as well.

---

## History

- 2026-02-20: Initial version
