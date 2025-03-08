using UnityEngine;
using UnityEditor;
using Flux;

namespace FluxEditor
{
    [CustomEditor(typeof(FTriggerBulletEvent))]
    public class FTriggerBulletEventInspector : FEventInspector
    {
        private FTriggerBulletEvent _bulletEvent = null;

        private SerializedProperty _range = null;
        private SerializedProperty _moveType = null;
        private SerializedProperty _initSpeed = null;
        private SerializedProperty _acceleration = null;
        private SerializedProperty _moveDistance = null;
        private SerializedProperty _triggerBuffId = null;
        private SerializedProperty _triggerBuffRate = null;

        private SerializedProperty _bulletId = null;
        private SerializedProperty _bulletPrefab = null;
        private SerializedProperty _bulletLink = null;
        private SerializedProperty _bulletFlyDuration = null;
        private SerializedProperty _bulletInitVelocity = null;
        private SerializedProperty _bulletAcceleration = null;
        private SerializedProperty _bulletAccelerationTime = null;
        private SerializedProperty _bulletTargetLink = null;

        private SerializedProperty _hitEffectId = null;
        private SerializedProperty _hitEffectPrefab = null;
        private SerializedProperty _hitEffectLink = null;


        int[] moveTypes = new int[] { 0, 1, 5 };
        string[] moveTypeStrs = new string[] { "无", "击退", "击飞" };

        private int bulletLinkIdx = -1;
        private int bulletTargetLinkIdx = -1;
        private int hitEffectLinkIdx = -1;

        protected override void OnEnable()
        {
            base.OnEnable();

            _bulletEvent = (FTriggerBulletEvent)target;

            
            _range = serializedObject.FindProperty("_range");
            _moveType = serializedObject.FindProperty("_moveType");
            _initSpeed = serializedObject.FindProperty("_initSpeed");
            _acceleration = serializedObject.FindProperty("_acceleration");
            _moveDistance = serializedObject.FindProperty("_moveDistance");
            _triggerBuffId = serializedObject.FindProperty("_triggerBuffId");
            _triggerBuffRate = serializedObject.FindProperty("_triggerBuffRate");

            _bulletId = serializedObject.FindProperty("_bulletId");
            _bulletPrefab = serializedObject.FindProperty("_bulletPrefab");
            _bulletLink = serializedObject.FindProperty("_bulletLink");
            _bulletFlyDuration = serializedObject.FindProperty("_bulletFlyDuration");
            _bulletInitVelocity = serializedObject.FindProperty("_bulletInitVelocity");
            _bulletAcceleration = serializedObject.FindProperty("_bulletAcceleration");
            _bulletAccelerationTime = serializedObject.FindProperty("_bulletAccelerationTime");
            _bulletTargetLink = serializedObject.FindProperty("_bulletTargetLink");

            _hitEffectId = serializedObject.FindProperty("_hitEffectId");
            _hitEffectPrefab = serializedObject.FindProperty("_hitEffectPrefab");
            _hitEffectLink = serializedObject.FindProperty("_hitEffectLink");

            for (int idx =0; idx < linkPoints.Length;idx++)
            {
                if(linkPoints[idx] == _bulletLink.stringValue)
                {
                    bulletLinkIdx = idx;
                    break;
                }
            }

            for(int idx = 0; idx < linkPoints.Length;idx++)
            {
                if(linkPoints[idx] == _bulletTargetLink.stringValue)
                {
                    bulletTargetLinkIdx = idx;
                    break;
                }
            }

            for(int idx = 0; idx < linkPoints.Length;idx++)
            {
                if(linkPoints[idx] == _hitEffectLink.stringValue)
                {
                    hitEffectLinkIdx = idx;
                    break;
                }
            }
        }

        public override void OnInspectorGUI()
        {
            base.OnInspectorGUI();

            serializedObject.Update();

            EditorGUILayout.BeginHorizontal();
            GUILayout.Label("子弹ID:", EditorStyles.label, GUILayout.Width(140));
            _bulletId.intValue = EditorGUILayout.IntField(_bulletId.intValue, GUILayout.Width(300));
            EditorGUILayout.EndHorizontal();

            EditorGUILayout.BeginHorizontal();
            GUILayout.Label("子弹预制体:", EditorStyles.label, GUILayout.Width(140));
            _bulletPrefab.objectReferenceValue = EditorGUILayout.ObjectField(_bulletPrefab.objectReferenceValue,typeof(GameObject),false, GUILayout.Width(300));
            EditorGUILayout.EndHorizontal();

            EditorGUILayout.BeginHorizontal();
            GUILayout.Label("子弹碰撞范围:", EditorStyles.label, GUILayout.Width(140));
            _range.vector3Value = EditorGUILayout.Vector3Field("",_range.vector3Value, GUILayout.Width(300));
            EditorGUILayout.EndHorizontal();

            EditorGUILayout.BeginHorizontal();
            GUILayout.Label("子弹挂载点:", EditorStyles.label, GUILayout.Width(140));
            bulletLinkIdx = EditorGUILayout.Popup(bulletLinkIdx, linkPoints,GUILayout.Width(300));
            if(bulletLinkIdx >= 0)
                _bulletLink.stringValue = linkPoints[bulletLinkIdx];
            EditorGUILayout.EndHorizontal();

            EditorGUILayout.BeginHorizontal();
            GUILayout.Label("子弹最长飞行时长:", EditorStyles.label, GUILayout.Width(140));
            _bulletFlyDuration.floatValue = EditorGUILayout.FloatField(_bulletFlyDuration.floatValue, GUILayout.Width(300));
            EditorGUILayout.EndHorizontal();

            EditorGUILayout.BeginHorizontal();
            GUILayout.Label("子弹初速度:", EditorStyles.label, GUILayout.Width(140));
            _bulletInitVelocity.vector3Value = EditorGUILayout.Vector3Field("", _bulletInitVelocity.vector3Value, GUILayout.Width(300));
            EditorGUILayout.EndHorizontal();

            EditorGUILayout.BeginHorizontal();
            GUILayout.Label("子弹加速度:", EditorStyles.label, GUILayout.Width(140));
            _bulletAcceleration.vector3Value = EditorGUILayout.Vector3Field("", _bulletAcceleration.vector3Value, GUILayout.Width(300));
            EditorGUILayout.EndHorizontal();

            EditorGUILayout.BeginHorizontal();
            GUILayout.Label("加速度时间:", EditorStyles.label, GUILayout.Width(140));
            _bulletAccelerationTime.floatValue = EditorGUILayout.FloatField(_bulletAccelerationTime.floatValue, GUILayout.Width(300));
            EditorGUILayout.EndHorizontal();

            EditorGUILayout.BeginHorizontal();
            GUILayout.Label("打中目标位置:", EditorStyles.label, GUILayout.Width(140));
            bulletTargetLinkIdx = EditorGUILayout.Popup(bulletTargetLinkIdx, linkPoints, GUILayout.Width(300));
            if(bulletTargetLinkIdx >= 0)
                _bulletTargetLink.stringValue = linkPoints[bulletTargetLinkIdx];
            EditorGUILayout.EndHorizontal();

            EditorGUILayout.BeginHorizontal();
            GUILayout.Label("命中特效id:", EditorStyles.label, GUILayout.Width(140));
            _hitEffectId.intValue = EditorGUILayout.IntField(_hitEffectId.intValue,GUILayout.Width(300));
            EditorGUILayout.EndHorizontal();

            EditorGUILayout.BeginHorizontal();
            GUILayout.Label("命中特效预设:", EditorStyles.label, GUILayout.Width(140));
            _hitEffectPrefab.objectReferenceValue = EditorGUILayout.ObjectField(_hitEffectPrefab.objectReferenceValue, typeof(GameObject), false, GUILayout.Width(300));

            GUILayout.Label("挂载点:", EditorStyles.label, GUILayout.Width(140));
            hitEffectLinkIdx = EditorGUILayout.Popup(hitEffectLinkIdx, linkPoints, GUILayout.Width(300));
            if (hitEffectLinkIdx >= 0)
                _hitEffectLink.stringValue = linkPoints[hitEffectLinkIdx];
            EditorGUILayout.EndHorizontal();


            EditorGUILayout.BeginHorizontal();
            GUILayout.Label("击中目标效果:", EditorStyles.label, GUILayout.Width(140));
            _moveType.intValue = EditorGUILayout.IntPopup(_moveType.intValue, moveTypeStrs, moveTypes, GUILayout.Width(300));
            EditorGUILayout.EndHorizontal();

            if(_moveType.intValue == (int)FighterMoveType.Beat_Back)
            {
                EditorGUILayout.BeginHorizontal();
                GUILayout.Label("击退初速度:", EditorStyles.label, GUILayout.Width(140));
                _initSpeed.floatValue = EditorGUILayout.FloatField(_initSpeed.floatValue);
                EditorGUILayout.EndHorizontal();

                EditorGUILayout.BeginHorizontal();
                GUILayout.Label("击退加速度:", EditorStyles.label, GUILayout.Width(140));
                _acceleration.floatValue = EditorGUILayout.FloatField(_acceleration.floatValue);
                EditorGUILayout.EndHorizontal();

                EditorGUILayout.BeginHorizontal();
                GUILayout.Label("击退距离:", EditorStyles.label, GUILayout.Width(140));
                _moveDistance.floatValue = EditorGUILayout.FloatField(_moveDistance.floatValue);
                EditorGUILayout.EndHorizontal();
            }else if(_moveType.intValue == (int)FighterMoveType.Beat_Fly)
            {
                EditorGUILayout.BeginHorizontal();
                GUILayout.Label("挑飞初速度:", EditorStyles.label, GUILayout.Width(140));
                _initSpeed.floatValue = EditorGUILayout.FloatField(_initSpeed.floatValue);
                EditorGUILayout.EndHorizontal();

                EditorGUILayout.BeginHorizontal();
                GUILayout.Label("挑飞加速度:", EditorStyles.label, GUILayout.Width(140));
                _acceleration.floatValue = EditorGUILayout.FloatField(_acceleration.floatValue);
                EditorGUILayout.EndHorizontal();

                EditorGUILayout.BeginHorizontal();
                GUILayout.Label("挑飞高度:", EditorStyles.label, GUILayout.Width(140));
                _moveDistance.floatValue = EditorGUILayout.FloatField(_moveDistance.floatValue);
                EditorGUILayout.EndHorizontal();
            }

            EditorGUILayout.BeginHorizontal();
            GUILayout.Label("触发buffID:", EditorStyles.label, GUILayout.Width(140));
            _triggerBuffId.intValue = EditorGUILayout.IntField(_triggerBuffId.intValue, GUILayout.Width(300));
            EditorGUILayout.EndHorizontal();

            EditorGUILayout.BeginHorizontal();
            GUILayout.Label("触发buff概率:", EditorStyles.label, GUILayout.Width(140));
            _triggerBuffRate.intValue = EditorGUILayout.IntField(_triggerBuffRate.intValue, GUILayout.Width(300));
            EditorGUILayout.EndHorizontal();


            serializedObject.ApplyModifiedProperties();
        }

    }
}