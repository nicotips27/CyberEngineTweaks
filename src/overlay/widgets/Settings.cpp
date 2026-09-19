#include <stdafx.h>

#include "Settings.h"

#include <CET.h>

#include <Utils.h>

Settings::Settings(Options& aOptions, LuaVM& aVm)
    : Widget("Settings")
    , m_options(aOptions)
    , m_vm(aVm)
{
    Load();
}

WidgetResult Settings::OnPopup()
{
    const auto ret = UnsavedChangesPopup("Settings", m_openChangesModal, m_madeChanges, [this] { Save(); }, [this] { Load(); });
    m_madeChanges = ret == TChangedCBResult::CHANGED;
    m_popupResult = ret;

    return m_madeChanges ? WidgetResult::ENABLED : WidgetResult::DISABLED;
}

WidgetResult Settings::OnDisable()
{
    if (m_enabled)
    {
        if (m_popupResult == TChangedCBResult::CANCEL)
        {
            m_popupResult = TChangedCBResult::APPLY;
            return WidgetResult::CANCEL;
        }

        if (m_madeChanges)
        {
            m_drawPopup = true;
            return WidgetResult::ENABLED;
        }

        m_enabled = false;
    }

    return m_enabled ? WidgetResult::ENABLED : WidgetResult::DISABLED;
}

void Settings::OnUpdate()
{
    const auto frameSize = ImVec2(ImGui::GetContentRegionAvail().x, -(ImGui::GetFrameHeight() + ImGui::GetStyle().ItemSpacing.y + ImGui::GetStyle().FramePadding.y + 2.0f));
    if (ImGui::BeginChild(ImGui::GetID("Settings"), frameSize))
    {
        m_madeChanges = false;
        if (ImGui::CollapsingHeader("Parches", ImGuiTreeNodeFlags_DefaultOpen))
        {
            ImGui::TreePush("##PARCHES");
            if (ImGui::BeginTable("##AJUSTES_PARCHES", 2, ImGuiTableFlags_Sortable | ImGuiTableFlags_SizingStretchSame, ImVec2(-ImGui::GetStyle().IndentSpacing, 0)))
            {
                const auto& patchesSettings = m_options.Patches;
                UpdateAndDrawSetting(
                    "Desactivar Compute Asíncrono",
                    "Desactiva el compute asíncrono, esto puede dar un impulso en GPUs antiguas como la serie Nvidia 10xx (requiere reinicio).",
                    m_patches.AsyncCompute, patchesSettings.AsyncCompute);
                UpdateAndDrawSetting(
                    "Desactivar Antialiasing", "Desactiva completamente el antialiasing (requiere reinicio).", m_patches.Antialiasing, patchesSettings.Antialiasing);
                UpdateAndDrawSetting(
                    "Desactivar Vigneteo", "Desactiva el vigneteo en los bordes de la pantalla (requiere reinicio).", m_patches.DisableVignette, patchesSettings.DisableVignette);
                UpdateAndDrawSetting(
                    "Desactivar Teletransporte de Límites", "Permite acceder a ubicaciones fuera de límites (requiere reinicio).", m_patches.DisableBoundaryTeleport,
                    patchesSettings.DisableBoundaryTeleport);
                UpdateAndDrawSetting(
                    "Desactivar V-Sync (solo Windows 7)", "Desactiva VSync en Windows 7 para saltar el límite de 60 FPS (requiere reinicio).", m_patches.DisableWin7Vsync,
                    patchesSettings.DisableWin7Vsync);
                
                ImGui::EndTable();
            }
            ImGui::TreePop();
        }
        if (ImGui::CollapsingHeader("Ajustes Desarrollo CET", ImGuiTreeNodeFlags_DefaultOpen))
        {
            ImGui::TreePush("##DESARROLLO");
            if (ImGui::BeginTable("##AJUSTES_DESARROLLO", 2, ImGuiTableFlags_Sortable | ImGuiTableFlags_SizingStretchSame, ImVec2(-ImGui::GetStyle().IndentSpacing, 0)))
            {
                const auto& developerSettings = m_options.Developer;
                UpdateAndDrawSetting(
                    "Eliminar Enlaces Muertos",
                    "Elimina todos los enlaces que ya no son válidos (desactivar puede ser útil al depurar mods).",
                    m_developer.RemoveDeadBindings, developerSettings.RemoveDeadBindings);
                UpdateAndDrawSetting(
                    "Activar Aserciones ImGui",
                    "Activa todas las aserciones de ImGui, se registrarán en el log (útil para depurar, verificar mods antes de publicar).",
                    m_developer.EnableImGuiAssertions, developerSettings.EnableImGuiAssertions);
                UpdateAndDrawSetting(
                    "Volcar Opciones del Juego", "Vuelca todas las opciones del juego al log principal (requiere reinicio).", m_developer.DumpGameOptions,
                    developerSettings.DumpGameOptions);
                UpdateAndDrawSetting(
                    "Activar JIT para Lua",
                    "Activa compilador JIT para VM Lua, acelera mods. Desactiva si hay problemas (requiere reinicio).",
                    m_developer.EnableJIT, developerSettings.EnableJIT);

                ImGui::EndTable();
            }
            ImGui::TreePop();
        }
    }
    ImGui::EndChild();

    ImGui::Separator();

    const auto itemWidth = GetAlignedItemWidth(3);
    if (ImGui::Button("Cargar", ImVec2(itemWidth, 0)))
        Load();
    ImGui::SameLine();
    if (ImGui::Button("Guardar", ImVec2(itemWidth, 0)))
        Save();
    ImGui::SameLine();
    if (ImGui::Button("Predeterminados", ImVec2(itemWidth, 0)))
        ResetToDefaults();
}

void Settings::Load()
{
    m_options.Load();

    m_patches = m_options.Patches;
    m_developer = m_options.Developer;
}

void Settings::Save() const
{
    m_options.Patches = m_patches;
    m_options.Developer = m_developer;

    m_options.Save();
}

void Settings::ResetToDefaults()
{
    m_options.ResetToDefaults();

    m_patches = m_options.Patches;
    m_developer = m_options.Developer;
}

void Settings::UpdateAndDrawSetting(const std::string& acLabel, const std::string& acTooltip, bool& aCurrent, const bool& acSaved)
{
    ImGui::TableNextRow();
    ImGui::TableNextColumn();

    ImVec4 curTextColor = ImGui::GetStyleColorVec4(ImGuiCol_Text);
    if (aCurrent != acSaved)
        curTextColor = ImVec4(1.0f, 1.0f, 0.0f, 1.0f);

    ImGui::AlignTextToFramePadding();

    ImGui::PushStyleColor(ImGuiCol_Text, curTextColor);

    ImGui::PushID(&acLabel);
    ImGui::TextUnformatted(acLabel.c_str());
    ImGui::PopID();

    if (ImGui::IsItemHovered(ImGuiHoveredFlags_AllowWhenDisabled) && !acTooltip.empty())
        ImGui::SetTooltip("%s", acTooltip.c_str());

    ImGui::TableNextColumn();

    ImGui::SetCursorPosX(ImGui::GetCursorPosX() + (ImGui::GetContentRegionAvail().x - ImGui::GetFrameHeight()) / 2);
    ImGui::Checkbox(("##" + acLabel).c_str(), &aCurrent);
    if (ImGui::IsItemHovered(ImGuiHoveredFlags_AllowWhenDisabled))
        ImGui::SetTooltip("%s", acTooltip.c_str());

    ImGui::PopStyleColor();

    m_madeChanges |= aCurrent != acSaved;
}
