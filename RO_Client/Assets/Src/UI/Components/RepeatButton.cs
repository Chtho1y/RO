using LuaInterface;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;

namespace UnityEngine.UI
{
    [RequireComponent(typeof(Button))]
    public class RepeatButton : MonoBehaviour, IPointerDownHandler, IPointerUpHandler, IPointerExitHandler
    {
        public int[] stage;

        public float[] delay;
        public int[] effTimes;

        [HideInInspector]
        public Button button;

        private float curEffTime;

        private bool isDown = false;

        private float startTime;

        private float lastIsDownTime;

        LuaTable table;
        LuaFunction effFunc;
        [NoToLua]
        void Start()
        {
            button = GetComponent<Button>();
            //button.onClick.AddListener(OnButtonClick);
        }

        public void AddRepeatClickEventListener(LuaFunction func)
        {
            effFunc = func;
        }

        public void AddRepeatClickEventListener(LuaTable table, LuaFunction func)
        {
            this.table = table;
            effFunc = func;
        }

        void OnButtonClick()
        {
          
        }

        [NoToLua]
        void Update()
        {
            if (isDown)
            {
                int index = 0;
                if (stage.Length > 0)
                {
                    for (int i = stage.Length - 1; i >= 0; --i)
                    {
                        float time = Time.time - startTime;
                        if (time >= stage[i])
                        {
                            index = i;
                            curEffTime = effTimes[index];
                            break;
                        }
                    }
                }

                if (Time.time - lastIsDownTime > delay[index])
                {
                    Effecive(index);
                }
            }
        }

        void Effecive(int index)
        {
            lastIsDownTime = Time.time;

            if (curEffTime > 0)
            {
                curEffTime -= 1;
                if (curEffTime == 0)
                {
                    if (index >= stage.Length - 1)
                    {
                        isDown = false;
                    }
                }
            }

            if (effFunc != null)
            {
                if (table == null)
                    effFunc.Call(index, !isDown);
                else
                    effFunc.Call(table, index, !isDown);
            }
        }

        [NoToLua]
        public void OnPointerDown(PointerEventData eventData)
        {
            isDown = true;
            startTime = Time.time;
            lastIsDownTime = startTime;
            int index = 0;

            curEffTime = effTimes[index];

            Effecive(0);
        }
        [NoToLua]
        public void OnPointerUp(PointerEventData eventData)
        {
            isDown = false;
        }
        [NoToLua]
        public void OnPointerExit(PointerEventData eventData)
        {
            isDown = false;
        }

        void OnDisable()
        {
            isDown = false;
        }

        public void ImmediatelyEffect()
        {
            if (effFunc != null)
            {
                if (table == null)
                    effFunc.Call(0, !isDown);
                else
                    effFunc.Call(table, 0, !isDown);
            }
        }
    }
}
