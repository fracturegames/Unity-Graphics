using NUnit.Framework;
using UnityEngine;
using System.Collections.Generic;
using UnityEngine.Rendering;


public interface IXRDepthMotionRenderer
{
    void RendererDepthMotionVector(RasterCommandBuffer cmd);
}

public class XRDepthMotionRenderers
{
    static List<IXRDepthMotionRenderer> _xrDepthMotionRenderers = new List<IXRDepthMotionRenderer>();

    public static void Register(IXRDepthMotionRenderer renderer)
    {
        _xrDepthMotionRenderers.Add(renderer);
    }

    public static void Unregister(IXRDepthMotionRenderer renderer)
    {
        _xrDepthMotionRenderers.Remove(renderer);
    }

    public static void RendererDepthMotionVectors(RasterCommandBuffer cmd)
    {
        foreach(var xrDepthMotionRenderer in _xrDepthMotionRenderers)
        {
            xrDepthMotionRenderer.RendererDepthMotionVector(cmd);
        }
    }
}
