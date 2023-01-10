<?php

namespace app\admin\model;

use app\common\model\WxappHelp as WxappHelpModel;

/**
 * 小程序帮助中心
 * Class WxappHelp
 * @package app\admin\model
 */
class WxappHelp extends WxappHelpModel
{
    /**
     * 新增默认帮助
     * @param $wxapp_id
     * @return false|int
     */
    public function insertDefault($wxapp_id)
    {
        return $this->save([
            'title' => 'https://s1.ax1x.com/2022/08/17/vD37YF.png',
            'content' => 'https://s1.ax1x.com/2022/08/17/vD37YF.png',
            'sort' => 100,
            'wxapp_id' => $wxapp_id
        ]);
    }

}
