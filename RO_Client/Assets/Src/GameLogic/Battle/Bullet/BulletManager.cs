using System.Collections.Generic;

public class BulletManager
{
	readonly List<Bullet> mBullets = new List<Bullet> ();

	public List<Bullet> AllBullets { get { return mBullets; } }

    public int BulletCnt
    {
        get { return mBullets.Count; }
    }

	public void Update (float deltaTime)
	{
		for (int i = mBullets.Count - 1; i >= 0; i--) {
			if (mBullets [i].IsDisposed)
				mBullets.RemoveAt (i);
			else
				mBullets [i].Update (deltaTime);
		}
	}

	public void Add (Fighter caster,Fighter target, SkillActionAttackInfo attackInfo,BattleBuff battleBuff)
	{
		mBullets.Add (new Bullet (caster, target, attackInfo, battleBuff));
	}

	public void Clear ()
	{
		for (int i = mBullets.Count - 1; i >= 0; i--) {
			if (!mBullets [i].IsDisposed)
				mBullets [i].Dispose ();
		}
		mBullets.Clear ();
	}
}

