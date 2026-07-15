import QtQuick
import QtQuick.Layouts
import M3Shapes
import Caelestia
import Caelestia.Config
import Caelestia.I18n
import qs.components
import qs.services
import qs.utils

StyledRect {
    id: root

    color: Colours.layer(Colours.palette.m3surfaceContainerHigh, 2)
    radius: Tokens.rounding.extraLargeIncreased
    implicitHeight: header.anchors.margins + header.implicitHeight + Tokens.spacing.medium + layout.implicitHeight + layout.anchors.bottomMargin

    RowLayout {
        id: header

        anchors.left: parent.left
        anchors.top: parent.top
        anchors.margins: Tokens.padding.largeIncreased

        spacing: Tokens.spacing.small

        MaterialIcon {
            Layout.topMargin: Math.round(fontInfo.pointSize * 0.12)
            text: "calendar_today"
            fontStyle: Tokens.font.icon.builders.medium.weight(title.font.weight).build()
        }

        StyledText {
            id: title

            text: Tr.tr("Daily forecast")
            font: Tokens.font.title.medium
        }
    }

    RowLayout {
        id: layout

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Tokens.padding.largeIncreased
        anchors.margins: Tokens.padding.large

        spacing: Tokens.spacing.small

        Repeater {
            model: CUtils.clamp(Math.floor((layout.width + layout.spacing) / (Tokens.sizes.lock.forecastItemWidth + layout.spacing)), 0, Weather.forecast.length)

            ColumnLayout {
                id: day

                required property int index
                readonly property var cond: Weather.forecast[index]

                Layout.fillWidth: true
                spacing: Tokens.spacing.extraSmall

                MaterialShape {
                    Layout.alignment: Qt.AlignHCenter
                    implicitSize: temp.implicitHeight + Tokens.padding.medium * 2
                    shape: MaterialShape.Cookie4Sided
                    color: Qt.alpha(Colours.palette.m3primary, day.index === 0 ? 1 : 0)

                    Behavior on color {
                        CAnim {}
                    }

                    StyledText {
                        id: temp

                        anchors.centerIn: parent
                        text: Weather.formatTemp(day.cond.maxTempC, true)
                        color: day.index === 0 ? Colours.palette.m3onPrimary : Colours.palette.m3onSurface
                        font: Tokens.font.title.medium
                    }
                }

                MaterialIcon {
                    Layout.alignment: Qt.AlignHCenter
                    text: day.cond.icon
                    color: Colours.palette.m3secondary
                    fontStyle: Tokens.font.icon.large
                }

                StyledText {
                    Layout.alignment: Qt.AlignHCenter
                    text: Weather.formatTemp(day.cond.minTempC, true)
                    color: Colours.palette.m3primary
                }

                StyledText {
                    Layout.topMargin: Tokens.spacing.extraSmall
                    Layout.alignment: Qt.AlignHCenter
                    text: day.index === 0 ? Tr.trCtx("Today", "forecast column") : new Date(day.cond.date).toLocaleDateString(Qt.locale(), "ddd")
                    color: Colours.palette.m3onSurfaceVariant
                    font: Tokens.font.body.medium
                }
            }
        }
    }
}
