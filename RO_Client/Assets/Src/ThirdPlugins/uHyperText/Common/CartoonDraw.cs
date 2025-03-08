using UnityEngine;
using UnityEngine.UI;
using System.Collections.Generic;

namespace WXB
{
    [ExecuteInEditMode]
    public class CartoonDraw : EffectDrawObjec, ICanvasElement
    {
        public override DrawType type { get { return DrawType.Cartoon; } }

        public Cartoon cartoon { get; set; }
        int frameIndex = 0;
        float mDelta = 0f;
        int curIdx = -1;

        void UpdateAnim(float deltaTime)
        {
            /*mDelta += Mathf.Min(1f, deltaTime);
            float delta = 5f;
            if (cartoon.fps.Length - 1 > frameIndex)
            {
                delta = cartoon.fps[frameIndex];
            }
            float rate = 1f / delta;

            while (rate < mDelta)
            {
                mDelta = (rate > 0f) ? mDelta - rate : 0f;

                if (++frameIndex >= cartoon.sprites.Length)
                {
                    frameIndex = 0;
                }
            }*/

            curIdx += 1;
            int delta = 1;
            if (cartoon.fps.Length - 1 > frameIndex)
            {
                delta = cartoon.fps[frameIndex] - 1;
            }

            if (curIdx >= delta)
            {
                curIdx = -1;
                if (++frameIndex >= cartoon.sprites.Length)
                {
                    frameIndex = 0;
                }
            }

            if (frameIndex < 0)
                frameIndex = 0;
        }

        class Data
        {
            public Vector2 leftPos;
            public Color color;
            public float width;
            public float height;

            public void Gen(VertexHelper vh, Vector4 uv, int xOffset, int yOffset)
            {
                int count = vh.currentVertCount;
                vh.AddVert(new Vector3(leftPos.x + xOffset, leftPos.y + yOffset), color, new Vector2(uv.x, uv.y));
                vh.AddVert(new Vector3(leftPos.x + xOffset, leftPos.y + height + yOffset), color, new Vector2(uv.x, uv.w));
                vh.AddVert(new Vector3(leftPos.x + width + xOffset, leftPos.y + height + yOffset), color, new Vector2(uv.z, uv.w));
                vh.AddVert(new Vector3(leftPos.x + width + xOffset, leftPos.y + yOffset), color, new Vector2(uv.z, uv.y));

                vh.AddTriangle(count, count + 1, count + 2);
                vh.AddTriangle(count + 2, count + 3, count);
            }
        }

        List<Data> mData = new List<Data>();

        public bool isOpenAlpha
        {
            get { return GetOpen(0); }
            set { SetOpen<AlphaEffect>(0, value); }
        }

        public bool isOpenOffset
        {
            get { return GetOpen(1); }
            set { SetOpen<OffsetEffect>(1, value); }
        }

        public void Add(Vector2 leftPos, float width, float height, Color color)
        {
            mData.Add(new Data() { leftPos = leftPos, color = color, width = width, height = height });
        }

        public override void UpdateSelf(float deltaTime)
        {
            base.UpdateSelf(deltaTime);
            int f = frameIndex;
            UpdateAnim(deltaTime);

            if (f != frameIndex)
            {
                CanvasUpdateRegistry.RegisterCanvasElementForGraphicRebuild(this);
            }
#if UNITY_EDITOR
            else
            {
                if (Application.isEditor)
                {
                    CanvasUpdateRegistry.RegisterCanvasElementForGraphicRebuild(this);
                }
            }
#endif
        }

        public override void Rebuild(CanvasUpdate executing)
        {
            if (executing != CanvasUpdate.PreRender)
                return;

            if (mData == null)
                return;

            Sprite s = cartoon.sprites[frameIndex];
            var uv = UnityEngine.Sprites.DataUtility.GetOuterUV(cartoon.sprites[frameIndex]);

            VertexHelper vh = Tools.vertexHelper;
            vh.Clear();
            for (int i = 0; i < mData.Count; ++i)
            {
                mData[i].Gen(vh, uv, cartoon.xOffset, cartoon.yOffset);
            }

            Mesh workerMesh = SymbolText.WorkerMesh;
            vh.FillMesh(workerMesh);
            canvasRenderer.SetMesh(workerMesh);
            canvasRenderer.SetTexture(s.texture);
        }

        public override void Release()
        {
            base.Release();
            mData.Clear();
            frameIndex = 0;
            curIdx = -1;
        }

        public override void GraphicUpdateComplete() { }
        public override bool IsDestroyed() { return this == null; }
        public override void LayoutComplete() { }
    }
}