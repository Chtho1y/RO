using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.U2D;
using UnityEngine.UI;
using UnityEngine.Sprites;


public class UIBigMapLine : MaskableGraphic
{
    [SerializeField]
	private float m_LineWidth = 10;
    [SerializeField]
	private int m_LineSmooth = 20;
	[SerializeField]
	private Sprite m_Sprite;
	
	
	[NonSerialized]
    private Sprite m_OverrideSprite;
	private bool m_Tracked = false;
	private int m_PassPointIdx = 0;
	private List<Vector2> m_Points = new List<Vector2>();

	private Sprite activeSprite { get { return m_OverrideSprite != null ? m_OverrideSprite : sprite; } }

	public Sprite sprite
    {
        get { return m_Sprite; }
        set
        {
            if (SetPropertyUtility.SetClass(ref m_Sprite, value))
            {
                SetAllDirty();
                TrackSprite();
            }
        }
    }

	public Sprite overrideSprite
    {
        get { return activeSprite; }
        set
        {
            if (SetPropertyUtility.SetClass(ref m_OverrideSprite, value))
            {
                SetAllDirty();
                TrackSprite();
            }
        }
    }

	public override Texture mainTexture
    {
        get
        {
            if (activeSprite == null)
            {
                if (material != null && material.mainTexture != null)
                {
                    return material.mainTexture;
                }
                return s_WhiteTexture;
            }

            return activeSprite.texture;
        }
    }

	public override Material material
    {
        get
        {
            if (m_Material != null)
                return m_Material;
#if UNITY_EDITOR
            if (Application.isPlaying && activeSprite && activeSprite.associatedAlphaSplitTexture != null)
                return Image.defaultETC1GraphicMaterial;
#else
        if (activeSprite && activeSprite.associatedAlphaSplitTexture != null)
            return Image.defaultETC1GraphicMaterial;
#endif
        return defaultMaterial;
    }
    set
    {
        base.material = value;
    }
}


    public int passPointIdx
    {
        set
        {
            if (m_PassPointIdx == value) return;
            m_PassPointIdx = value;
            SetAllDirty();
        }
    }

    public void AddPoint(Vector2 point)
    {
        m_Points.Add(point);
    }

    public void ClearPoints()
    {
        m_Points.Clear();
        SetAllDirty();
    }

    protected UIBigMapLine()
    {
        useLegacyMeshGeneration = false;
		raycastTarget = false;
    }
	
	protected override void OnEnable()
	{
		base.OnEnable();
		TrackSprite();
	}

	protected override void OnDisable()
	{
		base.OnDisable();
		if (m_Tracked)
			UnTrackUIBigMapLine(this);
	}

    protected override void OnPopulateMesh(VertexHelper vh)
    {
        if (m_Points == null || m_Points.Count < 2)
		{
			base.OnPopulateMesh(vh);
			return;
		}
		vh.Clear();
        List<Vector2> curvePoints = CalculateCurve(m_Points, m_LineSmooth, false);
		List<Vector2> vertices = GetVertices(curvePoints, m_LineWidth * 0.5f);
		int count = vertices.Count;
        int changeIdx = -1;

		var uv = (activeSprite != null) ? DataUtility.GetOuterUV(activeSprite) : Vector4.zero;
		Vector2 uv1, uv2;
        if (m_PassPointIdx > 0 && m_PassPointIdx < m_Points.Count)
        {
            changeIdx = m_LineSmooth * m_PassPointIdx * 2;
			uv1 = new Vector2(0.5f * (uv.z - uv.x) + uv.x, uv.y);
			uv2 = new Vector2(uv.z, uv.w);
        }
		else
		{
			uv1 = new Vector2(uv.x, uv.y);
			uv2 = new Vector2(0.5f * (uv.z - uv.x) + uv.x, uv.w);
		}
		
		for (int i = 0; i < count; i += 2)
		{
            vh.AddVert(vertices[i], color, uv2);
            if (i == changeIdx)
            {
                vh.AddVert(vertices[i + 1], color, uv1);
				uv1 = new Vector2(uv.x, uv.y);
				uv2 = new Vector2(0.5f * (uv.z - uv.x) + uv.x, uv.w);
                vh.AddVert(vertices[i], color, uv2);
				
            }
			vh.AddVert(vertices[i + 1], color, uv1);
		}

		int offset = 0;
		for (int i = 2; i < count; i += 2)
		{
			vh.AddTriangle(i - 2 + offset, i + offset, i - 1 + offset);
            vh.AddTriangle(i - 1 + offset, i + offset, i + 1 + offset);
			if (i == changeIdx)
			{
				offset = 2;
			}
		}
    }

	protected override void UpdateMaterial()
	{
		base.UpdateMaterial();
		if (activeSprite == null)
        {
            canvasRenderer.SetAlphaTexture(null);
            return;
        }
        Texture2D alphaTex = activeSprite.associatedAlphaSplitTexture;
        if (alphaTex != null)
        {
            canvasRenderer.SetAlphaTexture(alphaTex);
        }
	}

	private void TrackSprite()
    {
        if (activeSprite != null && activeSprite.texture == null)
        {
            TrackUIBigMapLine(this);
            m_Tracked = true;
        }
    }

	/// X = left, Y = bottom, Z = right, W = top.
    private Vector4 GetDrawingDimensions()
    {
        var padding = activeSprite == null ? Vector4.zero : DataUtility.GetPadding(activeSprite);
        var size = activeSprite == null ? Vector2.zero : new Vector2(activeSprite.rect.width, activeSprite.rect.height);

        // Rect r = GetPixelAdjustedRect();
        // Debug.Log(string.Format("r:{2}, size:{0}, padding:{1}", size, padding, r));

        int spriteW = Mathf.RoundToInt(size.x);
        int spriteH = Mathf.RoundToInt(size.y);

        var v = new Vector4(
            padding.x / spriteW,
            padding.y / spriteH,
            (spriteW - padding.z) / spriteW,
            (spriteH - padding.w) / spriteH);

        // v = new Vector4(
        //     r.x + r.width * v.x,
        //     r.y + r.height * v.y,
        //     r.x + r.width * v.z,
        //     r.y + r.height * v.w
        // );

        return v;
    }


























    public List<Vector2> CalculateCurve(IList<Vector2> points, int smooth, bool curveClose)
	{
		int pointCount = points.Count;
		int segmentCount = curveClose ? pointCount : pointCount - 1;
 
		List<Vector2> allVertices = new List<Vector2>((smooth + 1) * segmentCount);
		Vector2[] tempVertices = new Vector2[smooth + 1];
		float smoothReciprocal = 1f / smooth;
 
		for (int i = 0; i < segmentCount; ++i)
		{
			// get 4 adjacent point in points to calculate position between p1 and p2
			Vector2 p0, p1, p2, p3;
			p1 = points[i];
 
			if (curveClose)
			{
				p0 = i == 0 ? points[segmentCount - 1] : points[i - 1];
				p2 = i + 1 < pointCount ? points[i + 1] : points[i + 1 - pointCount];
				p3 = i + 2 < pointCount ? points[i + 2] : points[i + 2 - pointCount];
			}
			else
			{
				p0 = i == 0 ? p1 : points[i - 1];
				p2 = points[i + 1];
				p3 = i == segmentCount - 1 ? p2 : points[i + 2];
			}
 
			Vector2 pA = p1;
			Vector2 pB = 0.5f * (-p0 + p2);
			Vector2 pC = p0 - 2.5f * p1 + 2f * p2 - 0.5f * p3;
			Vector2 pD = 0.5f * (-p0 + 3f * p1 - 3f * p2 + p3);
 
			float t = 0;
			for (int j = 0; j <= smooth; j++)
			{
				tempVertices[j] = pA + t * (pB + t * (pC + t * pD));
				t += smoothReciprocal;
			}
			for (int j = allVertices.Count == 0 ? 0 : 1; j < tempVertices.Length; j++)
			{
				allVertices.Add(tempVertices[j]);
			}
		}
		return allVertices;
	}

    private List<CurveSegment2D> GetSegments(List<Vector2> points)
	{
		List<CurveSegment2D> segments = new List<CurveSegment2D>(points.Count - 1);
		for (int i = 1; i < points.Count; i++)
		{
			segments.Add(new CurveSegment2D(points[i - 1], points[i]));
		}
		return segments;
	}
 
	private List<Vector2> GetVertices(List<Vector2> points, float expands)
	{
		List<CurveSegment2D> segments = GetSegments(points);
 
		List<CurveSegment2D> segments1 = new List<CurveSegment2D>(segments.Count);
		List<CurveSegment2D> segments2 = new List<CurveSegment2D>(segments.Count);
 
		for (int i = 0; i < segments.Count; i++)
		{
			Vector2 vOffset = new Vector2(-segments[i].SegmentVector.y, segments[i].SegmentVector.x).normalized;
			segments1.Add(new CurveSegment2D(segments[i].point1 + vOffset * expands, segments[i].point2 + vOffset * expands));
			segments2.Add(new CurveSegment2D(segments[i].point1 - vOffset * expands, segments[i].point2 - vOffset * expands));
		}
 
		List<Vector2> points1 = new List<Vector2>(points.Count);
		List<Vector2> points2 = new List<Vector2>(points.Count);
 
		for (int i = 0; i < segments1.Count; i++)
		{
			if (i == 0)
			{
				points1.Add(segments1[0].point1);
			}
			else
			{
				Vector2 crossPoint;
				if (!TryCalculateLinesIntersection(segments1[i - 1], segments1[i], out crossPoint, 0.1f))
				{
					crossPoint = segments1[i].point1;
				}
				points1.Add(crossPoint);
			}
			if (i == segments1.Count - 1)
			{
				points1.Add(segments1[i].point2);
			}
		}
		for (int i = 0; i < segments2.Count; i++)
		{
			if (i == 0)
			{
				points2.Add(segments2[0].point1);
			}
			else
			{
				Vector2 crossPoint;
				if (!TryCalculateLinesIntersection(segments2[i - 1], segments2[i], out crossPoint, 0.1f))
				{
					crossPoint = segments2[i].point1;
				}
				points2.Add(crossPoint);
			}
			if (i == segments2.Count - 1)
			{
				points2.Add(segments2[i].point2);
			}
		}

		List<Vector2> combinePoints = new List<Vector2>(points.Count * 2);
		for (int i = 0; i < points.Count; i++)
		{
			combinePoints.Add(points1[i]);
			combinePoints.Add(points2[i]);
		}
		return combinePoints;
	}

    private List<Vector2> GetVerticesUV(List<Vector2> points)
	{
		List<Vector2> uvs = new List<Vector2>(points.Count * 2);
		float totalLength = 0;
		float totalLengthReciprocal = 0;
		float curLength = 0;
		for (int i = 1; i < points.Count; i++)
		{
			totalLength += Vector2.Distance(points[i - 1], points[i]);
		}
		totalLengthReciprocal = 1 / totalLength;
		for (int i = 0; i < points.Count; i++)
		{
			if (i == 0)
			{
				uvs.Add(new Vector2(0, 1));
				uvs.Add(new Vector2(0, 0));
			}
			else
			{
				if (i == points.Count - 1)
				{
					uvs.Add(new Vector2(1, 1));
					uvs.Add(new Vector2(1, 0));
				}
				else
				{
					curLength += Vector2.Distance(points[i - 1], points[i]);
					float uvx = curLength * totalLengthReciprocal;

					uvs.Add(new Vector2(uvx, 1));
					uvs.Add(new Vector2(uvx, 0));
				}
			}
		}
		return uvs;
	}

    private bool TryCalculateLinesIntersection(CurveSegment2D segment1, CurveSegment2D segment2, out Vector2 intersection, float angleLimit)
	{
		intersection = new Vector2();

		Vector2 p1 = segment1.point1;
		Vector2 p2 = segment1.point2;
		Vector2 p3 = segment2.point1;
		Vector2 p4 = segment2.point2;

		float denominator = (p2.y - p1.y) * (p4.x - p3.x) - (p1.x - p2.x) * (p3.y - p4.y);
		// If denominator is 0, means parallel
		if (denominator == 0)
		{
			return false;
		}

		// Check angle between segments
		float angle = Vector2.Angle(segment1.SegmentVector, segment2.SegmentVector);
		// if the angle between two segments is too small, we treat them as parallel
		if (angle < angleLimit || (180f - angle) < angleLimit)
		{
			return false;
		}

		float x = ((p2.x - p1.x) * (p4.x - p3.x) * (p3.y - p1.y)
				+ (p2.y - p1.y) * (p4.x - p3.x) * p1.x
				- (p4.y - p3.y) * (p2.x - p1.x) * p3.x) / denominator;
		float y = -((p2.y - p1.y) * (p4.y - p3.y) * (p3.x - p1.x)
				+ (p2.x - p1.x) * (p4.y - p3.y) * p1.y
				- (p4.x - p3.x) * (p2.y - p1.y) * p3.y) / denominator;

		intersection.Set(x, y);
		return true;
	}


    public struct CurveSegment2D
	{
		public Vector2 point1;
		public Vector2 point2;
		public CurveSegment2D(Vector2 point1, Vector2 point2)
		{
			this.point1 = point1;
			this.point2 = point2;
		}
		public Vector2 SegmentVector
		{
			get
			{
				return point2 - point1;
			}
		}
	}








	static List<UIBigMapLine> m_TrackedTexturelessImages = new List<UIBigMapLine>();
    static bool s_Initialized;

    static void RebuildImage(SpriteAtlas spriteAtlas)
    {
        for (var i = m_TrackedTexturelessImages.Count - 1; i >= 0; i--)
        {
            var g = m_TrackedTexturelessImages[i];
            if (spriteAtlas.CanBindTo(g.activeSprite))
            {
                g.SetAllDirty();
                m_TrackedTexturelessImages.RemoveAt(i);
            }
        }
    }

    private static void TrackUIBigMapLine(UIBigMapLine g)
    {
        if (!s_Initialized)
        {
            SpriteAtlasManager.atlasRegistered += RebuildImage;
            s_Initialized = true;
        }

        m_TrackedTexturelessImages.Add(g);
    }

    private static void UnTrackUIBigMapLine(UIBigMapLine g)
    {
        m_TrackedTexturelessImages.Remove(g);
    }
}
