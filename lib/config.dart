// Copyright (C) 2021 d1y <chenhonzhou@gmail.com>
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as
// published by the Free Software Foundation, either version 3 of the
// License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

/// 映射常量表
class ConstDart {
  /// 镜像索引
  static final String ls_mirrorIndex = "mirrorIndex";

  /// nsfw
  static final String is_nsfw = "isNsfw";

  /// 是否为暗色模式
  static final String ls_isDark = "isDark";

  /// 是否为开发模式
  /// TODDO
  static bool get isDev {
    return false;
  }
}
